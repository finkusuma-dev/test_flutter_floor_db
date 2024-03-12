import 'dart:developer' as dev;
import 'package:floor/floor.dart';
import 'package:test_floor/db/database.dart';
import 'package:test_floor/db/entity/hobby.dart';
import 'base.dart';

part 'person.dao.dart';

@entity
class Person extends BaseEntity {
  String name;
  int? age;
  
  DateTime? birthDate;

  Person({super.id, required this.name, this.age, this.birthDate});

  Future<List<Hobby>> getHobbies(AppDatabase db) async =>
      await db.personDao.getPersonHobbies(super.id!);

  Stream<List<Hobby>> getHobbiesAsStream(AppDatabase db) =>
      db.personDao.getPersonHobbiesAsStream(super.id!);

  Future<int> delete(AppDatabase db) async{
    return await db.personDao.deletePerson(db, this);
  }
}
