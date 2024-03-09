// your imports follow here
// import 'package:floor/floor.dart';
import 'package:test/test.dart';

import 'package:test_floor/db/database.dart';
import 'package:test_floor/db/entity/person.dart';

void main() {
  group('database tests', () {
    late AppDatabase database;
    late PersonDao personDao;

    setUp(() async {
      database = await $FloorAppDatabase
          .inMemoryDatabaseBuilder()
          .build();
      personDao = database.personDao;
    });

    tearDown(() async {
      await database.close();
    });

    test('find person by id', () async {
      final person = Person(id: 1, name: 'Simon');
      await personDao.insert(person);

      final actual = await personDao.getPerson(person.id);

      expect(actual!.id, equals(person.id));
      expect(actual.name, equals(person.name));
    });
  });
}