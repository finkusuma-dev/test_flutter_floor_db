import 'package:floor/floor.dart';

part 'person.dao.dart';

@entity
class Person {
  @primaryKey
  final int id;
  String name;
  int? age;

  Person({required this.id, required this.name, this.age});

  bool equalId(Person person) => person.id == id;
}