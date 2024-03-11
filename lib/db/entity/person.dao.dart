part of 'person.dart';


@dao
abstract class PersonDao extends BaseDao<Person>{
  @Query('select * from person')
  Future<List<Person>> getAllPersons();

  @Query('select * from Person where id=:id')
  Future<Person?> getPerson(int id);

  @Query('select * from name')
  Future<List<Name>> showName();
}

@DatabaseView('SELECT distinct(name) AS name FROM person', viewName: 'name')
class Name {
  final String name;

  Name(this.name);
}