import 'dart:developer' as dev;
import 'package:floor/floor.dart';
import 'base.dart';

part 'hobby.dao.dart';


@entity
class Hobby extends BaseEntity{
  String name;  
  int personId; 

  Hobby({super.id, required this.name, required this.personId});  
}