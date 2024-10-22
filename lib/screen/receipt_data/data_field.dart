import 'package:flutter/material.dart';

class DataField {
  TextEditingController textController = TextEditingController();
  TextEditingController? valueController;
  late TextField textField;
  late TextField valueField;

  DataField({String? text, String? value}) {
    if (text != null) {
      textController.text = text;
    }
    if (value != null) {
      valueController = TextEditingController();
      valueController!.text = value;
    }
    textField = TextField(
      autocorrect: false,
      controller: textController,
    );
    valueField = TextField(
      autocorrect: false,
      controller: valueController,
      style: const TextStyle(color: Colors.red),
    );
  }

  void dispose() {
    textController.dispose();
    valueController?.dispose();
  }

  get widget => Container(
    color: Colors.grey[800],
    child: Row(
          children: [
            Expanded(child: textField),
            Expanded(child: valueField),
          ],
        ),
  );

  String getText() => textController.text;
  String getValue() => valueController?.text ?? '';
}
