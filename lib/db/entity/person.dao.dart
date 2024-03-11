part of 'person.dart';


@dao
abstract class PersonDao extends BaseDao<Person>{
  @Query('select * from Person')
  Future<List<Person>> getAll();

  @Query('select * from Person where id=:id')
  Future<Person?> get(int id);

  @Query('select * from name')
  Future<List<Name>> showNames();
}

@DatabaseView('SELECT distinct(name) AS name FROM person', viewName: 'name')
class Name {
  final String name;

  Name(this.name);
}