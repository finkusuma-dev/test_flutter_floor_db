part of 'hobby.dart';

@dao
abstract class HobbyDao extends BaseDao<Hobby>{
  @Query('select * from Hobby')
  Future<List<Hobby>> getAll();

  @Query('select * from Hobby where id=:id')
  Future<Hobby?> get(int id);

  @Query('select * from Hobby where personId=:personId')
  Future<List<Hobby>> getPersonHobbies(int personId);

  Future<int> deletePersonHobbies(int personId) async{

    List<Hobby> hobbies = await getPersonHobbies(personId);

    return await deleteAllT(hobbies);
    
  }
}
