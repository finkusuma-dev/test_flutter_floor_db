// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'entity/person.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 2, entities: [Person])
abstract class AppDatabase extends FloorDatabase {
  PersonDao get personDao;
}

final migration1to2 = Migration(1,2, (db) async {
  await db.execute('ALTER TABLE Person ADD COLUMN age INTEGER');
});