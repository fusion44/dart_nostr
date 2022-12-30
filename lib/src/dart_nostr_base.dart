import 'package:dart_nostr/src/models/models.dart';
import 'package:hex/hex.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:bip340/bip340.dart' as bip340;

import 'constants.dart';
import 'exceptions/exceptions.dart';
import 'repositories/repositories.dart';
import 'utils.dart';

export 'subscription_filter.dart';

export 'models/models.dart';
export 'repositories/repositories.dart';
export 'requests/requests.dart';

class Nostr {
  static bool _isInitialized = false;
  static RelayRepository? _relayRepo;
  static ContactsRepository? _contactsRepo;
  static late String _dbName;

  static bool get isInitialized => _isInitialized;

  static RelayRepository get relays {
    if (!_isInitialized) throw Exception('Nostr not initialized');
    return _relayRepo!;
  }

  static ContactsRepository get contacts {
    if (!_isInitialized) throw Exception('Nostr not initialized');
    return _contactsRepo!;
  }

  static Future<void> init({
    required privKey,
    dbPath,
    dbName = defaultDatabaseName,
    bool dbInspector = false,
    Level logLevel = Level.INFO,
  }) async {
    _initLogger(logLevel);

    _dbName = dbName ?? defaultDatabaseName;

    await Isar.open(
      defaultSchemas,
      directory: dbPath,
      name: _dbName,
      inspector: dbInspector,
    );

    _relayRepo = RelayRepository();
    await _relayRepo!.init();
    _contactsRepo = ContactsRepository(_relayRepo!);
    await _contactsRepo!.init();

    log('dart_nostr successfully initialized');
    _isInitialized = true;
  }

  /// dispose of all resources. This will release all
  /// open databases and close all open streams
  static Future<void> dispose() async {
    await _relayRepo?.dispose();
    await _contactsRepo?.dispose();
    await Isar.getInstance(_dbName)?.close();

    log('dart_nostr successfully disposed');
  }

  /// generate a random set of credentials
  static Credentials genRandomCredentials() {
    final mnemonic = genMnemonic();

    return genCredentialsFromMnemonic(mnemonic);
  }

  /// generate a new mnemonic
  static String genMnemonic() => bip39.generateMnemonic();

  /// generate credentials from a given private key
  static Credentials genCredentialsFromPrivKey(String privKey) {
    final pubKey = bip340.getPublicKey(privKey);

    return Credentials(
      pubKey: Nip19KeySet.from(pubKey),
      privKey: privKey,
    );
  }

  /// Generate credentials from a given mnemonic
  ///
  /// throws [InvalidMnemonicError] if the given mnemonic is invalid
  static Credentials genCredentialsFromMnemonic(String mnemonic) {
    if (!bip39.validateMnemonic(mnemonic)) {
      throw InvalidMnemonicError();
    }

    final seed = bip39.mnemonicToSeed(mnemonic);
    final root = bip32.BIP32.fromSeed(seed);
    final privKey = HEX.encode(root.privateKey!.toList());
    final pubKey = bip340.getPublicKey(privKey);

    return Credentials(
      mnemonic: mnemonic,
      pubKey: Nip19KeySet.from(pubKey),
      privKey: privKey,
    );
  }
}

void _initLogger(Level level) {
  Logger.root.level = level;
  Logger.root.onRecord.listen((record) {
    final time =
        '${record.time.hour}:${record.time.minute}:${record.time.second}';
    print(
      '${record.loggerName}/${record.level.name}/$time: ${record.message}',
    );
  });
}
