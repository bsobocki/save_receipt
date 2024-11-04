import 'package:flutter/material.dart';
import 'package:save_receipt/screen/receipt_data/data_field/text_field.dart';
import 'package:save_receipt/screen/receipt_data/data_field/value_field.dart';

class DataField {
  String text;
  String? value;
  List<String>? values;
  TextEditingController textController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  DataField({required this.text, this.values, this.value}) {
    textController.text = text;
    if (value != null) {
      valueController.text = value!;
    }
  }

  void dispose() {
    textController.dispose();
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
                    defaultValue: value!,
                    values: values ?? [],
                    onSelected: (value) {
                      if (value != null) {
                        this.value = value;
                      }
                      print("selected: $value");
                    },
                    controller: valueController,
                  )
                : Container(),
          ]),
        ),
      );

  String getText() => textController.text;
  String getValue() => value ?? '';
}
