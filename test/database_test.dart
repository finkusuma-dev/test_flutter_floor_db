// your imports follow here
// import 'package:floor/floor.dart';
import 'dart:developer' as dev;
import 'dart:math';
import 'package:test/test.dart';

import 'package:test_floor/db/database.dart';
import 'package:test_floor/db/entity/hobby.dart';
import 'package:test_floor/db/entity/person.dart';

void main() {
  group('database tests\n:', () {
    late AppDatabase database;
    late PersonDao personDao;
    late HobbyDao hobbyDao;

    setUp(() async {
      database = await AppDatabase.memory();

      personDao = database.personDao;
      hobbyDao = database.hobbyDao;
    });

    tearDown(() async {
      await database.close();
    });

    group('Test Person', () {
      test('Get person by id', () async {
        final person = Person(name: 'Simon', age: 25);
        int id = await personDao.insert(
          person,
        );

        dev.log('person.id: ${person.id}');

        expect(id, isNotNull);

        final actual = await personDao.get(id);
        expect(person.id, actual!.id);
      });

      test('Get distinct name from Person', () async {
        final simon = Person(name: 'Simon', age: 25);
        final ali = Person(
          name: 'Ali',
        );
        await personDao.insert(
          simon,
        );
        await personDao.insert(
          ali,
        );

        final List<Name> names = await personDao.showNames();

        expect(names.any((element) => element.name == 'Simon'), true);
        expect(names.any((element) => element.name == 'Ali'), true);
      });

      test('Update person', () async {
        final person = Person(name: 'Simon', age: 25);
        await personDao.insert(
          person,
        );

        final actual = await personDao.get(person.id!);

        expect(actual!.equalId(person), isTrue);
        expect(actual.name, equals(person.name));
        expect(actual.age, equals(person.age));

        person.age = 30;
        await personDao.update(person);
        final actual2 = await personDao.get(person.id!);
        expect(actual2!.age, equals(person.age));
      });
    });

    group('Test Hobby:', () {
      test('Get persons\' hobbies', () async {
        final person = Person(name: 'Simon', age: 25);
        int personId = await personDao.insert(
          person,
        );

        List<String> hobbies = ['Reading', 'Fishing'];

        for (String hobbyStr in hobbies) {
          final Hobby hobby = Hobby(name: hobbyStr, personId: personId);
          await hobbyDao.insert(hobby);          
        }         

        List<Hobby> hobbiesList = await hobbyDao.getPersonHobbies(personId);

        expect(hobbiesList.every((hobby) => hobbies.contains(hobby.name)),
            true);

        List<Hobby> personHobbies = await personDao.getPersonHobbies(personId);

        expect(personHobbies.every((hobby) => hobbies.contains(hobby.name)),
            true);
      });
    });
  });
}
