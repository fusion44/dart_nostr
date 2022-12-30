import 'package:isar/isar.dart';
import 'package:logging/logging.dart';

import 'constants.dart';
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

  static Future<void> dispose() async {
    await _relayRepo?.dispose();
    await _contactsRepo?.dispose();
    await Isar.getInstance(_dbName)?.close();

    log('dart_nostr successfully disposed');
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
