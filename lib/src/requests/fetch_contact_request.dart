import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

    Contact? contact;

    for (final e in res.result) {
      final event = e as Event;
      if (event.kind == NostrKind.metadata) {
        final json = jsonDecode(event.content);
        Nip05 nip05 = Nip05.unverified();
        if (json.containsKey('nip05')) {
          nip05 = await _handleNip05(event.pubkey, json['nip05']);
        }

        contact = Contact(
          keyset: Nip19KeySet.from(event.pubkey),
          profile: Profile.fromJson(json, nip05),
        );

        if (nip05.verified) {
          // If we have a verified nip05, we can stop here
          break;
        }

        continue;
      }
    }

    return RequestResult(
      contact,
      forced: res.forced,
      forceReason: res.forceReason,
      relays: res.relays,
    );
  }

  Future<Nip05> _handleNip05(String pubkey, String nip05String) async {
    // https: //example.com/.well-known/nostr.json?name=bob
    final spl = nip05String.split('@');
    if (spl.length != 2) return Nip05.empty();
    final name = spl[0];
    final domain = spl[1];

    final uri = Uri.tryParse(
      'https://$domain/.well-known/nostr.json?name=$name',
    );
    if (uri == null) return Nip05.empty();

    final res = await http.read(uri);
    final nip05Res = jsonDecode(res);
    if (!nip05Res.containsKey('names')) return Nip05.unverified(domain);

    if (!nip05Res['names'].containsKey(name)) return Nip05.unverified(domain);

    final verifyKey = nip05Res['names'][name];
    if (verifyKey != pubkey) return Nip05.unverified(domain);

    return Nip05.verified(domain);
  }
}
