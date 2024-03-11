// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'entity/person.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 2, entities: [Person], views: [Name])
abstract class AppDatabase extends FloorDatabase {
  PersonDao get personDao;


  static Future<AppDatabase> memory() async {
    return await $FloorAppDatabase.inMemoryDatabaseBuilder().addMigrations(migrations).build();
  }
  
  static Future<AppDatabase> storage(String path) async {
    return await $FloorAppDatabase.databaseBuilder(path).addMigrations(migrations).build();
  }

  static List<Migration> migrations = [
    migration1to2
  ];
}

final migration1to2 = Migration(1, 2, (db) async {
  await db.execute('ALTER TABLE Person ADD COLUMN age INTEGER');
});