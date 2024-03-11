part of 'person.dart';


@dao
abstract class BaseDao<BaseEntity>{
  
  // @Query('select * from ${T.toString()} where id=:id')
  // Future<T?> get(int id);

  @Update()
  Future<void> update(BaseEntity obj);
  
}

@dao
abstract class PersonDao extends BaseDao<Person>{
  @Query('select * from person')
  Future<List<Person>> getAllPersons();

  @Query('select * from Person where id=:id')
  Future<Person?> getPerson(int id);

  @Insert()
  Future<int> insertA(Person person);
  
  Future<int> insert(Person person) async{
    int id = await insertA(person);
    person.id = id;
    return id;
  }


  // @Update()
  // Future<void> update(Person person);

  @Query('select * from name')
  Future<List<Name>> showName();
}

@DatabaseView('SELECT distinct(name) AS name FROM person', viewName: 'name')
class Name {
  final String name;

  Name(this.name);
}