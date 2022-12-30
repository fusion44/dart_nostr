import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:dart_nostr/src/constants.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';

Uint8List randomBytes32() {
  final rand = Random.secure();
  final bytes = Uint8List(32);
  for (var i = 0; i < 32; i++) {
    bytes[i] = rand.nextInt(256);
  }

  return bytes;
}

Isar getIsar() {
  final isar = Isar.getInstance(defaultDatabaseName);
  if (isar == null) throw StateError('Isar instance not initialized');

  return isar;
}

// https://isar.dev/recipes/string_ids.html
Id fastHash(String pubkey) {
  var hash = 0xcbf29ce484222325;

  var i = 0;
  while (i < pubkey.length) {
    final codeUnit = pubkey.codeUnitAt(i++);
    hash ^= codeUnit >> 8;
    hash *= 0x100000001b3;
    hash ^= codeUnit & 0xFF;
    hash *= 0x100000001b3;
  }

  return hash;
}

String jsonify(Object data, [bool prettyPrint = false]) {
  if (prettyPrint) {
    try {
      var encoder = const JsonEncoder.withIndent('  ');
      var prettyprint = encoder.convert(data);
      return prettyprint;
    } catch (e) {
      rethrow;
    }
  }

  return jsonEncode(data);
}

final logger = Logger(defaultLoggerName);

void log(String message, {level = Level.INFO}) {
  logger.log(level, message);
}
