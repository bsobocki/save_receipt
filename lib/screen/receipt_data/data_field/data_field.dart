import 'package:flutter/material.dart';
import 'package:save_receipt/screen/receipt_data/data_field/text_field.dart';

class DataField {
  TextEditingController textController = TextEditingController();
  TextEditingController? valueController;
  DataField({String? text, String? value}) {
    if (text != null) {
      textController.text = text;
    }
    if (value != null) {
      valueController = TextEditingController();
      valueController!.text = value;
    }
  }

  void dispose() {
    textController.dispose();
    valueController?.dispose();
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
            valueController != null
                ? DataTextField(
                    textController: valueController!,
                    textColor: Colors.grey[600],
                    textAlign: TextAlign.right,
                  )
                : Container(),
          ]),
        ),
      );

  String getText() => textController.text;
  String getValue() => valueController?.text ?? '';
}
