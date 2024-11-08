import 'package:flutter/material.dart';
import 'package:save_receipt/screen/receipt_data/data_field/text_field.dart';
import 'package:save_receipt/screen/receipt_data/data_field/value_field.dart';

class DataField {
  String text;
  String? value;
  List<String>? values;
  bool editing;
  TextEditingController textController = TextEditingController();

  DataField(
      {required this.text, this.values, this.value, this.editing = false}) {
    textController.text = text;
  }

  void dispose() {
    textController.dispose();
  }

  void setEditingMode() {
    editing = true;
    print('DataField: $text : editingMode set');
  }

  Widget widget(bool isDarker) => Container(
        decoration: BoxDecoration(
          color: isDarker ? Colors.black.withOpacity(0.02) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            DataTextField(
              textController: textController,
            ),
            value != null
                ? ValueField(
                    initValue: value!,
                    values: values ?? [],
                    onSelected: (value) {
                      if (value != null) {
                        this.value = value;
                      }
                      print("selected: $value");
                    },
                  )
                : Container(),
          ]),
        ),
      );

  String getText() => textController.text;
  String getValue() => value ?? '';
}
