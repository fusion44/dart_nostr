import 'dart:io';

import 'package:dart_nostr/dart_nostr.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';

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

  await Nostr.init(
    privKey: privKey,
    dbInspector: false,
    dbPath: '.',
    logLevel: Level.ALL,
  );

  for (var relay in relays) {
    await Nostr.relays.addRelay(relay);
  }

  // Find Jack's Metadata
  final data = await Nostr.contacts.fetchContact(
    Nip19KeySet.from(odell),
    timeoutDuration: Duration(seconds: 15),
  );
  print(data.result);

  await Nostr.dispose();

  exit(0);
}
