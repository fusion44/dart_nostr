import 'dart:async';
import 'dart:convert';

import '../constants.dart';
import '../models/models.dart';
import '../repositories/relay_repository.dart';
import '../subscription_filter.dart';
import '../utils.dart';
import 'auto_timeout_fetch_request.dart';
import 'request_result.dart';

class FetchContactRequest extends AutoTimeoutFetchRequest<Contact?> {
  final Nip19KeySet key;
  final bool useCache;

  Contact? _contact;

  RequestInfo? _reqInfo;

  FetchContactRequest(
    super.relayRepo, {
    required this.key,
    this.useCache = false,
    super.timeoutDuration,
  }) {
    if (useCache) {
      // TODO: implement me
      throw UnimplementedError('Cache not implemented yet');
    }
  }

  @override
  void onTimeout() async {
    // If we timeout, we need to cancel the request on the relay repo
    if (_reqInfo == null) return;
    repo.forceCompleteRequest(_reqInfo!.id, timeoutErrorDescription);
  }

  Future<RequestResult<Contact?>> fetch() async {
    if (isClosed) throw StateError('Request is already closed');

    if (useCache) {
      throw UnimplementedError('Cache not implemented yet');
      // TODO: implement me
    }

    final f = SubscriptionFilter(
      authors: [key.pubKeyHex],
      eventKinds: [NostrKind.metadata, NostrKind.recommendRelay],
    );

    final evtString = jsonify(['REQ', defaultIdToken, f.toJson()]);
    _reqInfo = repo.query(evtString);
    final res = await _reqInfo!.future;

    for (final e in res.result) {
      final event = e as Event;
      if (event.kind == NostrKind.metadata) {
        _contact = Contact(
          keyset: Nip19KeySet.from(event.pubkey),
          profile: Profile.fromJson(jsonDecode(event.content)),
        );

        continue;
      }
    }

    return RequestResult(
      _contact,
      forced: res.forced,
      forceReason: res.forceReason,
      relays: res.relays,
    );
  }
}
