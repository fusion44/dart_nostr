import 'dart:async';
import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../constants.dart';
import '../models/models.dart';
import '../requests/request_result.dart';
import '../utils.dart';

class RequestInfo {
  final String id;
  final Future future;

  RequestInfo(this.id, this.future);
}

class _ActiveRequestGroup {
  final String id;
  final Map<Relay, bool> _relays = {};
  final Map<String, Event> _events = {};
  final bool _partialUpdates;
  final Completer<RequestResult> _completer = Completer();
  final String query;

  _ActiveRequestGroup(this.id, this.query, [this._partialUpdates = false]);

  void addRelay(Relay r) => _relays[r] = false;

  void setEose(Relay r) {
    _relays[r] = true;
    if (isDone) _complete();
  }

  void addEvent(Relay r, Event e) {
    if (_events.containsKey(e.id)) {
      _events[e.id]!.relays.add(r);
      return;
    }

    _events[e.id] = e.copyWith(relays: [r]);
  }

  void forceComplete(String? reason) => _complete(true, reason);

  bool get isDone => _relays.values.every((e) => e);

  bool get partialUpdates => _partialUpdates;

  Future<RequestResult> get future => _completer.future;

  void _complete([bool forced = false, String? forceReason]) {
    if (_completer.isCompleted) {
      log(
        'Trying to complete an already completed completer (forced: $forced, reason: $forceReason)',
        level: Level.WARNING,
      );

      return;
    }

    _completer.complete(
      RequestResult(
        _events.values.toList(),
        id: id,
        complete: isDone,
        relays: _relays,
        forced: forced,
        forceReason: forceReason,
      ),
    );
  }
}

class RelayRepository {
  int _numRequests = 0;

  final List<Relay> _relays = [];
  final Map<Relay, WebSocketChannel> _channels = {};
  final Map<Relay, StreamSubscription> _subs = {};

  final _eventStreamController = StreamController<List<Event>>();
  late final Stream<List<Event>> _eventStream;
  final Map<String, Event> _eventMap = {};

  final _noticeStreamController = StreamController<String>();
  late final Stream<String> _noticeStream;
  final List<String> _notices = [];

  final _eoseStreamController = StreamController<String>();
  late final Stream<String> _eoseStream;

  late final Isar _isar;

  late final Map<String, _ActiveRequestGroup> _activeRequests = {};

  // we'll cache incoming events and send them every
  // x milliseconds to clients to avoid back pressure issues
  final int _flushTime = 500;
  List<Event> _eventCache = <Event>[];
  bool _awaitingFlush = false;

  /// Subscribe to new [Event] objects.
  /// Use [events] to get all [Event] objects received in the past.
  Stream<List<Event>> get eventsSub => _eventStream;

  /// Subscribe to new notices.
  /// Use [notices] to get all notices received in the past.
  Stream<String> get noticeSub => _noticeStream;

  // Subscribe to EOSE events
  Stream<String> get eoseSub => _eoseStream;

  List<Event> get events => _eventMap.values.toList();

  /// Get all events up to this point in time (Map<String, Event>)
  Map<String, Event> get eventMap => _eventMap;

  /// Get all notices up to this point in time
  List<String> get notices => _notices;

  /// Get all registered [Relay] objects
  List<Relay> get relays => _relays;

  Future<void> dispose() async {
    for (var sub in _subs.values) {
      await sub.cancel();
    }

    for (var k in _channels.keys) {
      log('Closing websocket to ${k.url}', level: Level.FINE);
      await _channels[k]?.sink.close();
    }
  }

  Future<void> init() async {
    _eventStream = _eventStreamController.stream.asBroadcastStream();
    _noticeStream = _noticeStreamController.stream.asBroadcastStream();
    _eoseStream = _eoseStreamController.stream.asBroadcastStream();

    _isar = getIsar();

    final res = await _isar.relays.where().findAll();

    if (res.isEmpty) return;

    _relays.addAll(res);

    for (final r in _relays) {
      _connectRelay(r);
    }
  }

  Future<void> toggleRelayActiveState(Relay r) async {
    if (!_relays.contains(r)) throw StateError('Relay not registered');

    await removeRelay(r);
    await addRelay(r.copyWith(active: !r.active));
  }

  Future<void> toggleRelayWriteState(Relay r) async {
    if (!_relays.contains(r)) throw StateError('Relay not registered');

    await removeRelay(r);
    await addRelay(r.copyWith(write: !r.write));
  }

  Future<void> toggleRelayReadState(Relay r) async {
    if (!_relays.contains(r)) throw StateError('Relay not registered');

    await removeRelay(r);
    await addRelay(r.copyWith(read: !r.read));
  }

  Future<void> addRelay(Relay r) async {
    if (_relays.contains(r)) return;

    _relays.add(r);
    if (r.active) _connectRelay(r);

    _relays.sort((a, b) {
      return a.url.compareTo(b.url);
    });

    await _storeRelays();
  }

  Future<void> removeRelay(dynamic r) async {
    if (r is Relay) {
      _relays.remove(r);
      await _disconnectRelay(r);
    } else if (r is String) {
      try {
        Uri.parse(r);
        final relay = _relays.firstWhere((Relay element) => r == element.url);
        await _disconnectRelay(relay);
        _relays.remove(relay);
      } catch (e) {
        log('Error while parsing the Uri: $r', level: Level.SEVERE);
      }
    } else {
      throw ArgumentError(
        'Argument must either be a Relay instance or a String containing the valid Relay url',
      );
    }
    await _storeRelays();
  }

  RequestInfo query(String query, [bool partialUpdates = false]) {
    final id = _genId();
    final q = query.replaceFirst(defaultIdToken, id);
    final grp = _ActiveRequestGroup(id, q, partialUpdates);
    _activeRequests[id] = grp;

    for (var r in _channels.keys) {
      final chan = _channels[r];
      if (chan == null) throw StateError('Channel for relay $r is null');
      grp.addRelay(r);
      chan.sink.add(q);
    }

    return RequestInfo(id, grp._completer.future);
  }

  void forceCompleteRequest(String reqId, [String? reason]) {
    if (_activeRequests.containsKey(reqId)) {
      final grp = _activeRequests.remove(reqId);

      if (grp == null) {
        throw StateError('Group for request $reqId is null');
      }

      grp.forceComplete(reason);
      for (var r in grp._relays.keys) {
        _channels[r]?.sink.add(jsonify(['CLOSE', reqId]));
      }

      return;
    }

    print(
      'Warning: Request $reqId not found when trying to force complete it',
    );
  }

  void _connectRelay(Relay r) {
    if (!r.active) return;
    log('Connecting to ${r.url}', level: Level.FINE);

    try {
      final chan = WebSocketChannel.connect(Uri.parse(r.url));

      final sub = _subscribe(chan, r);

      _channels[r] = chan;
      _subs[r] = sub;
    } catch (e) {
      log('Error while connecting to ${r.url}: $e', level: Level.SEVERE);
      rethrow;
    }
  }

  Future<void> _disconnectRelay(Relay r) async {
    if (r.active && _subs.containsKey(r)) {
      log('Disconnecting from ${r.url}', level: Level.FINE);
      final c = _channels.remove(r);
      c?.sink.close();
      final sub = _subs[r];
      await sub?.cancel();
      _subs.remove(r);
    }
  }

  StreamSubscription _subscribe(WebSocketChannel channel, Relay r) {
    return channel.stream.listen((event) async {
      dynamic data;
      try {
        data = jsonDecode(event);
      } catch (err) {
        // do nothing
      }

      if (data == null) {
        try {
          data = event.data;
        } catch (err) {
          log(
            'Error while parsing event: $event\nError: ${err.toString()}\n${r.url}',
            level: Level.SEVERE,
          );

          return;
        }
      }

      if (data == null) return;

      if (data[0] == 'EOSE') {
        // TODO: convert channel IDs to Strings everywhere
        // EOSE -	used to notify clients all stored events have been sent
        var id = data[1];
        log('Got EOSE for $id from ${r.url}', level: Level.FINEST);

        final req = _activeRequests[data[1]];
        if (req == null) return;

        req.setEose(r);

        if (req.isDone) {
          _eoseStreamController.sink.add(id);
          _eventStreamController.sink.add([...req._events.values.toList()]);
          forceCompleteRequest(id);
        }

        return;
      }

      if (data.length > 1) {
        if (data[0] == 'NOTICE') {
          if (data.length < 2) return;
          log(
            'Got NOTICE from relay ${r.url}: ${data[1]}',
            level: Level.WARNING,
          );
          _noticeStreamController.sink.add(data[1]);
          _notices.add(data[1]);
        }

        if (data[0] == 'EVENT') {
          if (data.length < 3) return;
          final id = data[1] ?? '0';
          log('Got EVENT for $id from ${r.url}', level: Level.FINEST);

          final evt = Event.fromJson(data[2], channel: id);
          final verified = await evt.verify();

          final req = _activeRequests[id];
          if (req == null) return;

          // if (!verified) {
          //   _eventStreamController.sink.addError(
          //     'Received unverifiable Event: ${evt.toJsonString()}',
          //   );
          // }

          final evt2 = evt.copyWith(verified: verified);

          if (req.partialUpdates) {
            _addEventToCache(evt2);
          }

          _eventMap[evt.id] = evt2;
          req.addEvent(r, evt2);
        }
      }
    }, onError: (err) {
      if (err.toString().contains('errno = 111')) {
        log('Unable to connect to relay: ${r.url}', level: Level.SEVERE);
        return;
      }

      log(
        'Error while receiving data from relay ${r.url}: $err',
        level: Level.SEVERE,
      );
    });
  }

  void _addEventToCache(Event e) {
    _eventCache.add(e);
    _flushEvents();
  }

  Future<void> _flushEvents() async {
    if (_awaitingFlush) return;
    _awaitingFlush = true;

    await Future.delayed(Duration(milliseconds: _flushTime));
    _eventStreamController.sink.add(_eventCache);
    _eventCache = [];
    _awaitingFlush = false;
  }

  Future<void> _storeRelays() async {
    await _isar.writeTxn(() async => await _isar.relays.putAll(_relays));
  }

  String _genId() => (_numRequests++).toString();
}
