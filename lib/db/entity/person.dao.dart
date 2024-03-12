part of 'person.dart';


@dao
abstract class PersonDao extends BaseDao<Person>{
  @Query('select * from Person')
  Future<List<Person>> getAll();

  @Query('select * from Person')
  Stream<List<Person>> getAllAsStream();

  @Query('select * from Person where id=:id')
  Future<Person?> get(int id);   
  
  @Query('select * from Hobby where personId=:personId')
  Future<List<Hobby>> getPersonHobbies(int personId); 
  
  @Query('select * from Hobby where personId=:personId')
  Stream<List<Hobby>> getPersonHobbiesAsStream(int personId); 

  @Query('select * from name')
  Future<List<Name>> showNames();

  Future<int> deletePerson(AppDatabase database, Person person) async{
    int count = await database.hobbyDao.deletePersonHobbies(person.id!);
    dev.log('$count ${person.name}\'s hobbies are deleted');


    return await super.deleteT(person);
  }
}

@DatabaseView('SELECT distinct(name) AS name FROM person', viewName: 'name')
class Name {
  final String name;

  Name(this.name);
}