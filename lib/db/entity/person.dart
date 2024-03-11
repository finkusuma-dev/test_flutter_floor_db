import 'package:floor/floor.dart';
import 'package:test_floor/db/database.dart';
import 'package:test_floor/db/entity/hobby.dart';
import 'base.dart';

part 'person.dao.dart';

@entity
class Person extends BaseEntity {
  String name;
  int? age;

  Person({super.id, required this.name, this.age});

  Future<List<Hobby>> getHobbies(AppDatabase db) async =>
      await db.personDao.getPersonHobbies(super.id!);
}
