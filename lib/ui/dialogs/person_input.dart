import 'package:flutter/material.dart';
import 'package:test_floor/db/entity/person.dart';
import 'package:test_floor/utils/general.dart';

Future<Person?> showPersonInputDialog(BuildContext context,
    {String title = ''}) async {
  return showDialog<Person?>(
    context: context,
    builder: (context) => PersonInputDialog(
      title: title,
    ),
  );
}

class PersonInputDialog extends StatefulWidget {
  const PersonInputDialog({super.key, this.title = ''});

  final String title;

  @override
  State<PersonInputDialog> createState() => _PersonInputDialogState();
}

class _PersonInputDialogState extends State<PersonInputDialog> {
  final TextEditingController _textFieldController = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();

  DateTime? birthDate;

  @override
  void initState() {
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
              Text('BirthDate: ${birthDate!= null ? General.dateFormat(birthDate!) : '(Not Set)'}'),
              TextButton(
                onPressed: () async {
                  birthDate = await showDatePicker(
                    context: context,
                    firstDate: birthDate ?? DateTime(1900, 1, 1),
                    lastDate: birthDate ?? DateTime.now(),
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
            Navigator.pop(context,
                Person(name: _textFieldController.text, birthDate: birthDate));
          },
        ),
      ],
    );
  }
}
