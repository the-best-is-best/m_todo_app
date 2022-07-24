import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../app/di.dart';

class SqfliteInit {
  Future initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'tasks.db');

    debugPrint('AppDatabaseInitialized');

    await _openAppDatabase(path);
  }

  Future _openAppDatabase(String path) async {
    await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute(
          """CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT , description TEXT , date TEXT , 
             startTime TEXT , endTime TEXT , remind INTEGER  , status INTEGER ,fav INTEGER , color TEXT )""",
        );

        debugPrint('Table Created');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute(
          """ALTER TABLE tasks ADD COLUMN description TEXT""",
        );
        debugPrint('Table Upgrade');
      },
      onOpen: (Database db) async {
        debugPrint('AppDatabaseOpened');

        di.registerFactory(() => db);
      },
    );
  }
}
