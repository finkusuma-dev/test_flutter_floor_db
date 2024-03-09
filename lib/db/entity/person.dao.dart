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
}