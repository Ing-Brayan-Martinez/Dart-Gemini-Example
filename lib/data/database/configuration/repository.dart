import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

abstract class Repository {
  Database? _instance;

  Future<Database> getDbConnection() async {
    if (_instance == null) {
      if (kDebugMode) {
        print('Using sqlite3 ${sqlite3.version}');
      }
      final Directory directory = await getApplicationDocumentsDirectory();
      final String fileName = path.join(directory.path, 'gemini_example.db');

      if (kDebugMode) {
        print(fileName);
      }

      final Database db =
          sqlite3.open(fileName, mode: OpenMode.readWriteCreate);

      _createTable(db);

      _instance = db;
    }

    return _instance!;
  }

  void _createTable(Database db) {
    // db.execute('''
    //     DROP TABLE Device;
    //   ''');

    db.execute('''
        CREATE TABLE IF NOT EXISTS Device (
          deviceID VARCHAR(255) NOT NULL PRIMARY KEY,
          isActive BOOLEAN NOT NULL,
          created DATETIME NOT NULL,
          updated DATETIME NOT NULL,
          name VARCHAR(255) NOT NULL,
          code VARCHAR(255) NOT NULL,
          status VARCHAR(255) NOT NULL,
          passKeyID VARCHAR(255) NULL
        );
      ''');

    if (kDebugMode) {
      print('Se creo la red web3 inicial');
    }
  }
}
