// your imports follow here
// import 'package:floor/floor.dart';
import 'dart:developer' as dev;
import 'package:test/test.dart';

import 'package:test_floor/db/database.dart';
import 'package:test_floor/db/entity/person.dart';

void main() {
  group('database tests\n:', () {
    late AppDatabase database;
    late PersonDao personDao;

    setUp(() async {
      database = await AppDatabase.memory();

      personDao = database.personDao;
    });

    tearDown(() async {
      await database.close();
    });

    test('Get person by id', () async {
      final person = Person(name: 'Simon', age: 25);
      int id = await personDao.insert(person,);      

      dev.log('person.id: ${person.id}');

      expect(id, isNotNull);

      final actual = await personDao.getPerson(id);
      expect(person.id, actual!.id);      

      // expect(actual!.equalId(person), isTrue);
      // expect(actual.name, equals(person.name));
      // // expect(actual.age, equals(25));
      // expect(actual.age, equals(person.age));

      // final List<Name> names = await personDao.showName();
            
      // expect(names.any((element) => element.name == 'Simon'), true);
    });

    test('Get distinct name from Person', () async {
      final simon = Person(name: 'Simon', age: 25);
      final ali = Person(name: 'Ali',);
      await personDao.insert(simon,);
      await personDao.insert(ali,);

      final List<Name> names = await personDao.showName();
            
      expect(names.any((element) => element.name == 'Simon'), true);
      expect(names.any((element) => element.name == 'Ali'), true);
    });

    test('Update person', () async {
      final person = Person(name: 'Simon', age: 25);
      await personDao.insert(person,);

      final actual = await personDao.getPerson(person.id!);

      expect(actual!.equalId(person), isTrue);
      expect(actual.name, equals(person.name));      
      expect(actual.age, equals(person.age));

      person.age = 30;
      await personDao.update(person);
      final actual2 = await personDao.getPerson(person.id!);
      expect(actual2!.age, equals(person.age));

    });
  });
}
