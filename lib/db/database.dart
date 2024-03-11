// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'entity/person.dart';
import 'entity/hobby.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 3, entities: [Person, Hobby], views: [Name])
abstract class AppDatabase extends FloorDatabase {
  PersonDao get personDao;
  HobbyDao get hobbyDao;

  static Future<AppDatabase> memory() async {
    return await $FloorAppDatabase
        .inMemoryDatabaseBuilder()
        .addMigrations(migrations)
        .build();
  }

  static Future<AppDatabase> storage(String path) async {
    return await $FloorAppDatabase
        .databaseBuilder(path)
        .addMigrations(migrations)
        .build();
  }

  static List<Migration> migrations = [migration1to2, migration2to3];
}

final migration1to2 = Migration(1, 2, (db) async {
  await db.execute('ALTER TABLE Person ADD COLUMN age INTEGER');
});
final migration2to3 = Migration(2, 3, (db) async {
  await db.execute(
      'CREATE TABLE IF NOT EXISTS `Hobby` (`name` TEXT NOT NULL, `personId` INTEGER, `id` INTEGER PRIMARY KEY AUTOINCREMENT)');
});
