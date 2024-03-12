import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:test_floor/db/database.dart';
import 'package:test_floor/db/entity/hobby.dart';
import 'package:test_floor/db/entity/person.dart';
import 'package:test_floor/ui/dialogs/input.dart';
import 'package:test_floor/ui/dialogs/person_input.dart';
import 'package:test_floor/utils/app_folder.dart';
import 'package:test_floor/utils/general.dart';
import 'package:test_floor/utils/platform_info.dart';

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
  ///
  Stream<List<Person>>? peopleStream;
  Stream<List<Stream<String>>>? peopleHobbies;
  AppDatabase? database;

  @override
  void initState() {
    () async {
      var docPath =
          await AppFolder.document(); //getApplicationDocumentsDirectory();

      String dbPath = path.join(docPath.path, 'data.db');
      dev.log('db path: $dbPath');
      // database = await AppDatabase.memory();
      database = await AppDatabase.storage(dbPath);
      peopleStream = database!.personDao.getAllAsStream();

      Future.delayed(Duration.zero, () {
        setState(() {});
      });
    }();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const HSLColor.fromAHSL(1, 100, 1, 1).toColor(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SizedBox(
        child:
            database != null ? _peopleStreamBuilder() : const SizedBox.shrink(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleInsertNewPerson,
        label: const Text('Insert Person'),
        // child: const Text('Insert Person'),
      ),
    );
  }

  StreamBuilder<List<Person>> _peopleStreamBuilder() {
    return StreamBuilder<List<Person>>(
      stream: peopleStream,
      builder: (context, peopleResult) {
        if (peopleResult.hasData) {
          var people = peopleResult.data!;
          return ListView.separated(
            separatorBuilder: (_, int i) => Divider(
              height: 1,
              color: Colors.grey.withOpacity(0.5),
            ),
            itemCount: peopleResult.data!.length + 1,
            itemBuilder: (_, int i) {
              return i <= peopleResult.data!.length - 1
              ? PersonWidget(              
                person: people[i],
                database: database!,
              ) : const SizedBox(height: 90,);
            },
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
    );
  }

  void _handleInsertNewPerson() async {
    Person? person = await showPersonInputDialog(context, title: 'Person');
    if (person == null) return;

    await database?.personDao.insert(person);

    setState(() {});
  }
}

class PersonWidget extends StatefulWidget {
  const PersonWidget({super.key, required this.person, required this.database});

  final Person person;
  final AppDatabase database;

  @override
  State<PersonWidget> createState() => _PersonWidgetState();
}

class _PersonWidgetState extends State<PersonWidget> {
  ///
  List<Hobby> hobbies = [];
  late StreamSubscription streamSubcription;

  @override
  void initState() {
    dev.log('subscribe to ${widget.person.name}\'s hobbies');
    streamSubcription = widget.person
        .getHobbiesAsStream(widget.database)
        .listen((hobbiesEvent) {
      dev.log('${widget.person.name}\'s hobbies event stream triggered');
      hobbies = hobbiesEvent;
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    dev.log('disposing ${widget.person.name}\'s hobbies streamSubscription');
    streamSubcription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        dev.log(
            'Person id = ${widget.person.id}, name = ${widget.person.name}');
      },
      child: ListTile(
        contentPadding: const EdgeInsets.only(right: 6, left: 20),
        title: Text(widget.person.name),
        subtitle: widget.person.birthDate != null || hobbies.isNotEmpty
            ? Row(
                children: [
                  Text(widget.person.birthDate != null
                      ? General.dateFormat(widget.person.birthDate!)
                      : ''),
                  Text(widget.person.birthDate != null && hobbies.isNotEmpty
                      ? ' | '
                      : ''),
                  Text(
                    hobbies
                        .map(
                          (e) => e.name,
                        )
                        .join(', '),
                  ),
                ],
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _addHobbyButton(),
            _deleteButton(),
            
          ],
        ),
      ),
    );
  }

  FilledButton _addHobbyButton() {
    return FilledButton(
      style: const ButtonStyle(
        // backgroundColor: MaterialStatePropertyAll(
        //   // Colors.purple[4/00] as Color
        // ),
        padding: MaterialStatePropertyAll(
          EdgeInsets.symmetric(vertical: 1, horizontal: 15),
        ),
      ),
      onPressed: _handleAddHobby,
      child: const Text(
        'Add hobby',
        style: TextStyle(fontSize: 10),
      ),
    );
  }

  void _handleAddHobby() async {
    String? newHobby = await showInputDialog(context,
        title: 'New hobby of ${widget.person.name}');

    if (newHobby == null) return;
    widget.database.hobbyDao.insert(
      Hobby(name: newHobby, personId: widget.person.id!),
    );
  }

  Widget _deleteButton() {
    return IconButton(
              onPressed: () {
                widget.database.personDao.deletePerson(
                  widget.database,
                  widget.person,
                );
              },
              icon: Icon(
                Icons.delete_outline_rounded,
                color: Colors.red[700],
              ),
            );
  }
}
