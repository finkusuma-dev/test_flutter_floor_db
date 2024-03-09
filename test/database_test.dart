// your imports follow here
// import 'package:floor/floor.dart';
import 'package:test/test.dart';

import 'package:test_floor/db/database.dart';
import 'package:test_floor/db/entity/person.dart';

void main() {
  group('database tests\n:', () {
    late AppDatabase database;
    late PersonDao personDao;

    setUp(() async {
      database =
          await $FloorAppDatabase.inMemoryDatabaseBuilder().addMigrations([
        migration1to2,
      ]).build();

      personDao = database.personDao;
    });

    tearDown(() async {
      await database.close();
    });

    test('Get person by id', () async {
      final person = Person(id: 1, name: 'Simon', age: 25);
      await personDao.insert(person,);

      final actual = await personDao.getPerson(person.id);

      expect(actual!.equalId(person), isTrue);
      expect(actual.name, equals(person.name));
      // expect(actual.age, equals(25));
      expect(actual.age, equals(person.age));
    });
  });
}
