import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_floor/db/database.dart';
import 'package:test_floor/db/entity/hobby.dart';
import 'package:test_floor/db/entity/person.dart';
import 'package:test_floor/db/ui/dialogs/input.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Floor',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Test Floor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Stream<List<Person>>? people;
  AppDatabase? database;
  
  
  @override
  void initState() {
    () async {
      var docPath = await getApplicationDocumentsDirectory();
      String dbPath = '${docPath.path}/data.db';
      dev.log('path: $dbPath');
      // database = await AppDatabase.memory();
      database = await AppDatabase.storage((dbPath));
      people = database!.personDao.getAllAsStream();

      Future.delayed(Duration.zero, () {
        setState(() {});
      });
    }();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SizedBox(
        child: database != null
            ? StreamBuilder<List<Person>>(
                stream: people,
                builder: (context, peopleResult) {
                  if (peopleResult.hasData) {
                    var people = peopleResult.data!;
                    return ListView.separated(
                      separatorBuilder: (_, int i) => Divider(
                        height: 1,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                      itemCount: peopleResult.data!.length,
                      itemBuilder: (_, int i) => _personWidget(
                        id: people[i].id!,
                        person: people[i],
                      ),
                    );
                  } else if (peopleResult.hasError) {
                    return Center(
                      child: Text('Error ${peopleResult.error!.toString()}'),
                    );
                  }
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.hourglass_top,
                          color: Colors.orange,
                          size: 40,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Loading data',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              )
            : const SizedBox.shrink(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          String? name = await showInputDialog(context, title: 'Person');
          if (name == null) return;

          await database?.personDao.insert(
            Person(name: name),
          );

          setState(() {});
        },
        label: const Text('Insert Person'),
        // child: const Text('Insert Person'),
      ),
    );
  }

  Widget _personWidget({required int id, required Person person}) {
    return InkWell(
      onTap: () {
        dev.log('Person id = ${id}, name = ${person.name}');
      },
      child: ListTile(
        title: Text(person.name),
        subtitle: //_getPersonHobbies(person.id!),
        FutureBuilder<List<Hobby>>(
            future: person.getHobbies(database!),
            builder: (context, hobbyResult) {
              if (hobbyResult.hasData) {
                return Text(hobbyResult.data!.map((el) => el.name).join(', '));
              }

              return Container();
            }),
        trailing: FilledButton(
          style: const ButtonStyle(
              // backgroundColor: MaterialStatePropertyAll(
              //   // Colors.purple[4/00] as Color
              // ),
              padding: MaterialStatePropertyAll(
                  EdgeInsets.symmetric(vertical: 1, horizontal: 15))),
          onPressed: () async {
            String? newHobby = await showInputDialog(context,
                title: 'New Hobby of ${person.name}');

            if (newHobby == null) return;
            database?.hobbyDao
                .insert(Hobby(name: newHobby, personId: person.id!));

            setState(() {});

            dev.log('');
          },
          child: const Text(
            'Add hobby',
            style: TextStyle(fontSize: 10),
          ),
        ),
      ),
    );
  }

   dynamic _getPersonHobbies(int personId) async{
    List<Hobby>? hobbies = await database?.personDao.getPersonHobbies(personId);
    if (hobbies == null || hobbies.isEmpty) return null;
    return Text(hobbies.map((el) => el.name).join(', '));
    
  }
}
