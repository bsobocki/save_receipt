import 'package:flutter/material.dart';
import 'package:save_receipt/screen/receipt_data/data_field/text_field.dart';
import 'package:save_receipt/screen/receipt_data/data_field/value_field.dart';
import 'package:save_receipt/source/data/structures/data_field.dart';
import 'package:save_receipt/source/data/structures/receipt.dart';

class DataField extends StatefulWidget {
  final DataFieldModel model;
  final AllValuesModel allValues;
  final bool isDarker;
  const DataField(
      {super.key,
      required this.model,
      required this.allValues,
      required this.isDarker});

  get text => null;

  @override
  State<DataField> createState() => _DataFieldState();
}

class _DataFieldState extends State<DataField> {
  TextEditingController textController = TextEditingController();

  List<String> allValuesForType(ReceiptObjectType type) {
    switch (type) {
      case ReceiptObjectType.product:
        return widget.allValues.prices;
      case ReceiptObjectType.date:
        return widget.allValues.dates;
      case ReceiptObjectType.info:
        return widget.allValues.info;
      default:
        return [];
    }
  }

  @override
  void initState() {
    super.initState();
    textController.text = widget.model.text;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columnContent = [
      DataTextField(textController: textController)
    ];

    if (widget.model.value != null) {
      Widget valueField = ValueField(
        initValue: widget.model.value!,
        values: allValuesForType(widget.model.type),
        onSelected: (value) {
          setState(() {
            if (value != null) {
              widget.model.value = value;
            }
          });
          print("selected: $value");
        },
      );

      if (widget.model.isEditing) {
        Widget valueRemoveButton = IconButton(
          onPressed: () => setState(() => widget.model.value = null),
          icon: const Icon(
            Icons.cancel,
            color: Color.fromARGB(163, 138, 2, 2),
          ),
        );

        Widget valueTypeMenu = PopupMenuButton<String>(
          onSelected: (String value) {
            ReceiptObjectType type = ReceiptObjectType.object;
            switch (value) {
              case 'price':
                type = ReceiptObjectType.product;
                break;

              case 'info':
                type = ReceiptObjectType.info;
                break;

              case 'date':
                type = ReceiptObjectType.date;
            }
            setState(() {
              widget.model.type = type;
            });
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'price', child: Text('price')),
            const PopupMenuItem(value: 'date', child: Text('date')),
            const PopupMenuItem(value: 'info', child: Text('info')),
          ],
          child: const Icon(Icons.type_specimen, color: Color.fromARGB(183, 255, 193, 7),),
        );

        columnContent.add(
            Row(children: [Expanded(child: valueField), valueRemoveButton, valueTypeMenu]));
      } else {
        columnContent.add(valueField);
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: widget.isDarker ? Colors.black.withOpacity(0.03) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: columnContent),
      ),
    );
  }
}
