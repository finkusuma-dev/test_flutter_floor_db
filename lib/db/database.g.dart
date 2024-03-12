// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PersonDao? _personDaoInstance;

  HobbyDao? _hobbyDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 3,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Person` (`name` TEXT NOT NULL, `age` INTEGER, `id` INTEGER PRIMARY KEY AUTOINCREMENT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Hobby` (`name` TEXT NOT NULL, `personId` INTEGER NOT NULL, `id` INTEGER PRIMARY KEY AUTOINCREMENT)');

        await database.execute(
            'CREATE VIEW IF NOT EXISTS `name` AS SELECT distinct(name) AS name FROM person');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PersonDao get personDao {
    return _personDaoInstance ??= _$PersonDao(database, changeListener);
  }

  @override
  HobbyDao get hobbyDao {
    return _hobbyDaoInstance ??= _$HobbyDao(database, changeListener);
  }
}

class _$PersonDao extends PersonDao {
  _$PersonDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _personInsertionAdapter = InsertionAdapter(
            database,
            'Person',
            (Person item) => <String, Object?>{
                  'name': item.name,
                  'age': item.age,
                  'id': item.id
                },
            changeListener),
        _personUpdateAdapter = UpdateAdapter(
            database,
            'Person',
            ['id'],
            (Person item) => <String, Object?>{
                  'name': item.name,
                  'age': item.age,
                  'id': item.id
                },
            changeListener),
        _personDeletionAdapter = DeletionAdapter(
            database,
            'Person',
            ['id'],
            (Person item) => <String, Object?>{
                  'name': item.name,
                  'age': item.age,
                  'id': item.id
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Person> _personInsertionAdapter;

  final UpdateAdapter<Person> _personUpdateAdapter;

  final DeletionAdapter<Person> _personDeletionAdapter;

  @override
  Future<List<Person>> getAll() async {
    return _queryAdapter.queryList('select * from Person',
        mapper: (Map<String, Object?> row) => Person(
            id: row['id'] as int?,
            name: row['name'] as String,
            age: row['age'] as int?));
  }

  @override
  Stream<List<Person>> getAllAsStream() {
    return _queryAdapter.queryListStream('select * from Person',
        mapper: (Map<String, Object?> row) => Person(
            id: row['id'] as int?,
            name: row['name'] as String,
            age: row['age'] as int?),
        queryableName: 'Person',
        isView: false);
  }

  @override
  Future<Person?> get(int id) async {
    return _queryAdapter.query('select * from Person where id=?1',
        mapper: (Map<String, Object?> row) => Person(
            id: row['id'] as int?,
            name: row['name'] as String,
            age: row['age'] as int?),
        arguments: [id]);
  }

  @override
  Future<List<Hobby>> getPersonHobbies(int personId) async {
    return _queryAdapter.queryList('select * from Hobby where personId=?1',
        mapper: (Map<String, Object?> row) => Hobby(
            id: row['id'] as int?,
            name: row['name'] as String,
            personId: row['personId'] as int),
        arguments: [personId]);
  }

  @override
  Stream<List<Hobby>> getPersonHobbiesAsStream(int personId) {
    return _queryAdapter.queryListStream(
        'select * from Hobby where personId=?1',
        mapper: (Map<String, Object?> row) => Hobby(
            id: row['id'] as int?,
            name: row['name'] as String,
            personId: row['personId'] as int),
        arguments: [personId],
        queryableName: 'Hobby',
        isView: false);
  }

  @override
  Future<List<Name>> showNames() async {
    return _queryAdapter.queryList('select * from name',
        mapper: (Map<String, Object?> row) => Name(row['name'] as String));
  }

  @override
  Future<int> insertA(Person obj) {
    return _personInsertionAdapter.insertAndReturnId(
        obj, OnConflictStrategy.abort);
  }

  @override
  Future<void> update(Person obj) async {
    await _personUpdateAdapter.update(obj, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteA(Person obj) {
    return _personDeletionAdapter.deleteAndReturnChangedRows(obj);
  }

  @override
  Future<int> deleteAllT(List<Person> list) {
    return _personDeletionAdapter.deleteListAndReturnChangedRows(list);
  }
}

class _$HobbyDao extends HobbyDao {
  _$HobbyDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _hobbyInsertionAdapter = InsertionAdapter(
            database,
            'Hobby',
            (Hobby item) => <String, Object?>{
                  'name': item.name,
                  'personId': item.personId,
                  'id': item.id
                },
            changeListener),
        _hobbyUpdateAdapter = UpdateAdapter(
            database,
            'Hobby',
            ['id'],
            (Hobby item) => <String, Object?>{
                  'name': item.name,
                  'personId': item.personId,
                  'id': item.id
                },
            changeListener),
        _hobbyDeletionAdapter = DeletionAdapter(
            database,
            'Hobby',
            ['id'],
            (Hobby item) => <String, Object?>{
                  'name': item.name,
                  'personId': item.personId,
                  'id': item.id
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Hobby> _hobbyInsertionAdapter;

  final UpdateAdapter<Hobby> _hobbyUpdateAdapter;

  final DeletionAdapter<Hobby> _hobbyDeletionAdapter;

  @override
  Future<List<Hobby>> getAll() async {
    return _queryAdapter.queryList('select * from Hobby',
        mapper: (Map<String, Object?> row) => Hobby(
            id: row['id'] as int?,
            name: row['name'] as String,
            personId: row['personId'] as int));
  }

  @override
  Future<Hobby?> get(int id) async {
    return _queryAdapter.query('select * from Hobby where id=?1',
        mapper: (Map<String, Object?> row) => Hobby(
            id: row['id'] as int?,
            name: row['name'] as String,
            personId: row['personId'] as int),
        arguments: [id]);
  }

  @override
  Future<List<Hobby>> getPersonHobbies(int personId) async {
    return _queryAdapter.queryList('select * from Hobby where personId=?1',
        mapper: (Map<String, Object?> row) => Hobby(
            id: row['id'] as int?,
            name: row['name'] as String,
            personId: row['personId'] as int),
        arguments: [personId]);
  }

  @override
  Future<int> insertA(Hobby obj) {
    return _hobbyInsertionAdapter.insertAndReturnId(
        obj, OnConflictStrategy.abort);
  }

  @override
  Future<void> update(Hobby obj) async {
    await _hobbyUpdateAdapter.update(obj, OnConflictStrategy.abort);
  }

  @override
  Future<int> deleteA(Hobby obj) {
    return _hobbyDeletionAdapter.deleteAndReturnChangedRows(obj);
  }

  @override
  Future<int> deleteAllT(List<Hobby> list) {
    return _hobbyDeletionAdapter.deleteListAndReturnChangedRows(list);
  }
}
