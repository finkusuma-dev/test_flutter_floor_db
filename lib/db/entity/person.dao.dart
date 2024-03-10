part of 'person.dart';

@dao
abstract class PersonDao {
  @Query('select * from person')
  Future<List<Person>> getAllPersons();

  @Query('select * from Person where id=:id')
  Future<Person?> getPerson(int id);

  @Insert()
  Future<void> insert(Person person);

  @Update()
  Future<void> update(Person person);

  @Query('select * from name')
  Future<List<Name>> showName();
}

@DatabaseView('SELECT distinct(name) AS name FROM person', viewName: 'name')
class Name {
  final String name;

  Name(this.name);
}