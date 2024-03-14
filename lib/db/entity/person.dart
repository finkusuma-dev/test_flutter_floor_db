import 'dart:developer' as dev;
import 'package:floor/floor.dart';
import 'package:test_floor/db/database.dart';
import 'package:test_floor/db/entity/hobby.dart';
import 'package:test_floor/utils/general.dart';
import 'base.dart';

part 'person.dao.dart';

enum Gender {
  male,
  female;
}

@entity
class Person extends BaseEntity {
  String name;
  int? age;

  DateTime? birthDate;

  Gender? gender;

  Person({super.id, required this.name, this.age, this.birthDate, this.gender});

  Future<List<Hobby>> getHobbies(AppDatabase db) async =>
      await db.personDao.getPersonHobbies(super.id!);

  Stream<List<Hobby>> getHobbiesAsStream(AppDatabase db) =>
      db.personDao.getPersonHobbiesAsStream(super.id!);

  // Future<int> delete(AppDatabase db) async {
  //   return await db.personDao.deletePerson(db, this);
  // }

  @override
  String toString() {
    return 'id: ${super.id}, name: $name, age: $age, '
        'birthDate: ${birthDate != null ? General.dateFormat(birthDate!) : null}, '
        'gender: ${gender?.name}';
  }
}
