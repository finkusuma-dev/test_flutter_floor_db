// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'entity/person.dart';
import 'entity/hobby.dart';
import 'type_converters/date_time_converter.dart';

part 'database.g.dart'; // the generated code will be there

@TypeConverters([DateTimeConverter])
@Database(version: 5, entities: [Person, Hobby], views: [Name])
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

  static List<Migration> migrations = [
    migration1to2,
    migration2to3,
    migration3to4,
    migration4to5,
  ];
}

final migration4to5 = Migration(4, 5, (db) async {
  await db.execute(
    'ALTER TABLE Person ADD COLUMN gender INTEGER',
  );
});
final migration3to4 = Migration(3, 5, (db) async {
  await db.execute(
    'ALTER TABLE Person ADD COLUMN birthDate INTEGER',
  );
});
final migration2to3 = Migration(2, 5, (db) async {
  await db.execute(
      'CREATE TABLE IF NOT EXISTS `Hobby` (`name` TEXT NOT NULL, `personId` INTEGER, `id` INTEGER PRIMARY KEY AUTOINCREMENT)');
});
final migration1to2 = Migration(1, 5, (db) async {
  await db.execute(
    'ALTER TABLE Person ADD COLUMN age INTEGER',
  );
});
