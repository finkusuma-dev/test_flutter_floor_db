import 'package:floor/floor.dart';

part 'person.dao.dart';

@entity
class Person {
  @primaryKey
  final int id;
  String name;

  Person({required this.id, required this.name});
}