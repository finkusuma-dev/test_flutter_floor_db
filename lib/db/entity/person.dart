import 'package:floor/floor.dart';

part 'person.dao.dart';

@entity
class Person {
  @PrimaryKey(autoGenerate: true)
  int? id;
  String name;
  int? age;

  Person({this.id, required this.name, this.age});

  bool equalId(Person person) => person.id == id;
}