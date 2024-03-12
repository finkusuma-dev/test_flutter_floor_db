import 'package:flutter/material.dart';
import 'package:test_floor/db/entity/person.dart';
import 'package:test_floor/utils/general.dart';

Future<Person?> showPersonInputDialog(BuildContext context,
    {String title = '', Person? person}) async {
  return showDialog<Person?>(
    context: context,
    builder: (context) => PersonInputDialog(
      title: title,
      person: person,
    ),
  );
}

class PersonInputDialog extends StatefulWidget {
  const PersonInputDialog(
      {super.key, this.title = '', this.person, this.gender});

  final String title;
  final Person? person;
  final Gender? gender;

  @override
  State<PersonInputDialog> createState() => _PersonInputDialogState();
}

class _PersonInputDialogState extends State<PersonInputDialog> {
  final TextEditingController _textFieldController = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();

  int? _id;
  Gender? _gender;
  DateTime? _birthDate;
  // Person? person;

  @override
  void initState() {
    //person = widget.person ?? Person(name: name);
    _textFieldController.text = widget.person?.name ?? '';
    _id = widget.person?.id;
    _birthDate = widget.person?.birthDate;
    _gender = widget.person?.gender;

    _textFieldFocusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            focusNode: _textFieldFocusNode,
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Enter ${widget.title}"),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Text('Gender:'),
              DropdownButton<Gender>(
                onChanged: (Gender? value) {
                  setState(() {
                    _gender = value;
                  });
                },
                value: _gender,
                items: Gender.values
                    .map(
                      (value) => DropdownMenuItem<Gender>(
                        value: value,
                        child: Text(value.name),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                'BirthDate: ${_birthDate != null ? General.dateFormat(_birthDate!) : '(Not Set)'}',
              ),
              TextButton(
                onPressed: () async {
                  _birthDate = await showDatePicker(
                    context: context,
                    firstDate: _birthDate ?? DateTime(1900, 1, 1),
                    lastDate: _birthDate ?? DateTime.now(),
                    initialDate: _birthDate,
                  );

                  setState(() {});
                },
                child: const Text(
                  'Set',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          )
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          child: const Text('OK'),
          onPressed: () {
            // print(_textFieldController.text);
            Navigator.pop(
              context,
              Person(
                id: _id,
                name: _textFieldController.text,
                gender: _gender,
                birthDate: _birthDate,
              ),
            );
          },
        ),
      ],
    );
  }
}
