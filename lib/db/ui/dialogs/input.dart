import 'package:flutter/material.dart';


Future<String?> showInputDialog(BuildContext context, {String title = ''}) async {
  return showDialog<String>(
    context: context,
    builder: (context) => InputDialog(title: title,),
  );
}

class InputDialog extends StatefulWidget {
  const InputDialog({super.key, this.title = ''});

  final String title;

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  final TextEditingController _textFieldController = TextEditingController();
  final FocusNode _textFieldFocusNode = FocusNode();

  @override
  void initState() {
    _textFieldFocusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        focusNode: _textFieldFocusNode,
        controller: _textFieldController,
        decoration: InputDecoration(hintText: "Enter ${widget.title}"),
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
            Navigator.pop(context, _textFieldController.text);
          },
        ),
      ],
    );
    
  }
}
