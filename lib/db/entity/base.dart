import 'package:floor/floor.dart';

@entity
abstract class BaseEntity {
  @PrimaryKey(autoGenerate: true)  
  int? id;
  BaseEntity({this.id});

  bool equalId(BaseEntity obj) => obj.id == id;
}


@dao
abstract class BaseDao<T>{
  
  // @Query('select * from ${T.toString()} where id=:id')
  // Future<T?> get(int id);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> update(T obj);


  @Insert()
  Future<int> insertA(T obj);
  
  Future<int> insert(T obj) async{    
    int id = await insertA(obj);
    (obj as BaseEntity).id = id;
    return id;
  }
  
  @delete
  Future<int> deleteA(T obj);

  Future<int> deleteT(T obj) async {
    int id = await deleteA(obj);
    return id;
  }

  @delete
  Future<int> deleteAllT(List<T> list);
}