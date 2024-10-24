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
      controller: textController,
      style: const TextStyle(color: Colors.black26),
      decoration: const InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(90.0)),
          borderSide: BorderSide(color: Colors.black26),
        ),
      ),
    );
    valueField = TextField(
      controller: valueController,
      style: const TextStyle(color: Colors.red),
      decoration: const InputDecoration(
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(90.0)),
          borderSide: BorderSide(color: Colors.black26),
        ),
      ),
    );
  }

  void dispose() {
    textController.dispose();
    valueController?.dispose();
  }

  get widget => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Expanded(child: textField),
        const SizedBox(width: 40),
        SizedBox(width:100, child: valueField),
      ],
    ),
  );

  String getText() => textController.text;
  String getValue() => valueController?.text ?? '';
}
