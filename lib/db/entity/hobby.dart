import 'dart:developer' as dev;
import 'package:floor/floor.dart';
import 'package:test_floor/db/entity/person.dart';
import 'base.dart';

part 'hobby.dao.dart';

@Entity(foreignKeys: [
  ForeignKey(
    childColumns: ['personId'],
    parentColumns: ['id'],
    entity: Person,
    onDelete: ForeignKeyAction.cascade,
    onUpdate: ForeignKeyAction.cascade
  )
])
class Hobby extends BaseEntity {
  String name;
  int personId;

  Hobby({super.id, required this.name, required this.personId});
}
