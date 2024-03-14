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
@Database(
  version: 6,
  entities: [Person, Hobby],
  views: [Name],
)
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
    migration5to6,
  ];
}

final migration5to6 = Migration(5, 6, (db) async {
  /// Add hobby foreign key personId => Person(id), update & delete cascade
  /// 
  await db.execute('PRAGMA foreign_keys = 0;'
      'CREATE TABLE sqlitestudio_temp_table AS SELECT * '
      '                                           FROM Hobby; '
      'DROP TABLE Hobby;'
      ' '
      'CREATE TABLE Hobby ( '
      '    name     TEXT    NOT NULL, '
      '    personId INTEGER NOT NULL, '
      '    id       INTEGER, '
      '    PRIMARY KEY ( '
      '        id AUTOINCREMENT '
      '    ), '
      '    FOREIGN KEY ( '
      '        personId '
      '    ) '
      '    REFERENCES Person (id) ON DELETE CASCADE '
      '                           ON UPDATE CASCADE '
      '); '      
      'INSERT INTO Hobby ( '
      '                      name, '
      '                      personId, '
      '                      id '
      '                  ) '
      '                  SELECT name, '
      '                         personId, '
      '                         id '
      '                    FROM sqlitestudio_temp_table; '
      ' '
      'DROP TABLE sqlitestudio_temp_table; '      
      'PRAGMA foreign_keys = 1; ');
});
final migration4to5 = Migration(4, 5, (db) async {
  await db.execute(
    'ALTER TABLE Person ADD COLUMN gender INTEGER',
  );
});
final migration3to4 = Migration(3, 4, (db) async {
  await db.execute(
    'ALTER TABLE Person ADD COLUMN birthDate INTEGER',
  );
});
final migration2to3 = Migration(2, 3, (db) async {
  await db.execute(
      'CREATE TABLE IF NOT EXISTS `Hobby` (`name` TEXT NOT NULL, `personId` INTEGER, `id` INTEGER PRIMARY KEY AUTOINCREMENT)');
});
final migration1to2 = Migration(1, 2, (db) async {
  await db.execute(
    'ALTER TABLE Person ADD COLUMN age INTEGER',
  );
});
