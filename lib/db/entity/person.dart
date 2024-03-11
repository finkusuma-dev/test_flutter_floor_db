import 'package:floor/floor.dart';

part 'person.dao.dart';


@entity
abstract class BaseEntity {
  @PrimaryKey(autoGenerate: true)  
  int? id;
  BaseEntity({this.id});
}

@entity
class Person extends BaseEntity{
  String name;
  int? age;

  Person({super.id, required this.name, this.age});

  bool equalId(Person person) => person.id == id;
}