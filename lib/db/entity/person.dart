import 'package:floor/floor.dart';
import 'base.dart';

part 'person.dao.dart';


@entity
class Person extends BaseEntity{
  String name;
  int? age;

  Person({super.id, required this.name, this.age});

  bool equalId(Person person) => person.id == id;
}