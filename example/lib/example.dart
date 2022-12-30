import 'dart:async';
import 'dart:io';

import 'package:dart_nostr/dart_nostr.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';

const mnemonic =
    'source stone proof found obey hungry senior bunker disorder brief denial flame';

// Pubkey of Jack Dorsey
const jack = 'npub1sg6plzptd64u62a878hep2kev88swjh3tw00gjsfl8f237lmu63q0uf63m';
const odell =
    '04c915daefee38317fa734444acee390a8269fe5810b2241e5e6dd343dfbecc9';

const privKey =
    '4d6a9aeb5279a45ae3b972f1c7c08acb82e10b30a397d738c5cf84251df92902';

final relayUrls = [
  "wss://relay.damus.io",
  'wss://relay.nostr.info',
  "wss://nostr-2.zebedee.cloud",
  "wss://nostr.semisol.dev",
  "wss://nostr.coinos.io",
  "wss://nostr-relay.digitalmob.ro",
  "wss://nostr.drss.io",
  "wss://nostr.radixrat.com",
  "wss://relay.nostr.ch",
];

final relays = [
  for (var url in relayUrls)
    Relay(url: url, read: true, write: true, active: true)
];

void main(List<String> args) async {
  // Isar needs native libraries.
  // This is only necessary for non Flutter apps
  await Isar.initializeIsarCore(download: true);

  // Generate new random credentials
  // final creds = Nostr.genRandomCredentials();
  final creds = Nostr.genCredentialsFromMnemonic(mnemonic);

  // Initialize Nostr
  await Nostr.init(
    privKey: creds.privKey,
    dbInspector: false,
    dbPath: '.',
    logLevel: Level.INFO,
  );

  for (var relay in relays) {
    await Nostr.relays.addRelay(relay);
  }

  await lowLevelExample();
  await highLevelExample();

  await Nostr.dispose();
  exit(0);
}

Future<void> highLevelExample() async {
  // Find Jack's Metadata
  final data = await Nostr.contacts.fetchContact(
    Nip19KeySet.from(jack),
    timeoutDuration: Duration(seconds: 2),
  );
  print(data.result?.toJson());
}

RequestInfo? _reqInfo;
Completer<void> _completer = Completer();

Future<void> _startTimeout() async {
  // Since a Relay might be out of order we have to set a manual timeout
  await Future.delayed(Duration(seconds: 5));
  if (!_completer.isCompleted) {
    _completer.complete();
    if (_reqInfo != null) {
      // Tell Nostr to cancel the request
      Nostr.relays.forceCompleteRequest(_reqInfo!.id);
    }
  }
}

Future<void> lowLevelExample() async {
  // Nostr is initialized in example.dart, so we can use it here

  // Subscribe to EOSE events
  final eoseSub = Nostr.relays.eoseSub.listen((id) {
    print('Received EOSE event for id $id');
  });

  // Subscribe to NOTICE events. These are sent when a relay encountered
  // an error while processing a request
  final noticeSub = Nostr.relays.noticeSub.listen((id) {
    print('Received NOTICE event for id $id');
  });

  // Subscribe to all events
  final eventSub = Nostr.relays.eventsSub.listen((events) {
    // ℹ️ 1: Events are sent in batches every 500 ms
    // ℹ️ 2: Events will only be sent if realtime updates are requested
    //       when starting the query
    // ℹ️ 3: Events might contain events from other queries, so a id check is necessary.
    //       The request id is part of the RequestInfo object returned by .query()
    print('Received ${events.length} events');
  });

  // Subscribe to events from a specific author
  final f = SubscriptionFilter(
    authors: [Nip19KeySet.from(odell).pubKeyHex],
    eventKinds: [NostrKind.note],
    since: DateTime.now().subtract(Duration(days: 5)),
    limit: 15,
  );

  // Generate the query string
  final q = Nostr.genQueryString(f);

  // Send the event to the relays
  _reqInfo = Nostr.relays.query(q, realtimeUpdates: false);

  // Note, if we don't set the timeout, the request may never complete
  // if a relay doesn't respond with an EOSE event for a request
  unawaited(_startTimeout());

  final res = await _reqInfo!.future;
  if (!_completer.isCompleted) {
    _completer.complete();
  }

  List<Event> noteEvents = [];
  if (res.result is List<Event>) {
    final events = res.result as List<Event>;
    for (var e in events) {
      if (e.kind == NostrKind.note) {
        noteEvents.add(e);
        continue;
      }

      print(e.kind);
    }
    print('Received ${events.length} events');
  }

  for (int i = 0; i < noteEvents.length; i++) {
    var e = noteEvents[i];
    print('$i ========================');
    print(e.content);
    print('${e.createdAtDt.toIso8601String()} by @ODELL');
  }

  print('========================');

  await Future.delayed(Duration(seconds: 5));
  await eoseSub.cancel();
  await noticeSub.cancel();
  await eventSub.cancel();
}
