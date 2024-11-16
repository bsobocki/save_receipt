import 'package:flutter/material.dart';
import 'package:save_receipt/color/colors.dart';
import 'package:save_receipt/color/gradient.dart';
import 'package:save_receipt/screen/receipt_data/data_field/text_field.dart';
import 'package:save_receipt/screen/receipt_data/data_field/value_field.dart';
import 'package:save_receipt/source/data/structures/data_field.dart';
import 'package:save_receipt/source/data/structures/receipt.dart';

class DataField extends StatefulWidget {
  final DataFieldModel model;
  final AllValuesModel allValuesData;
  final bool isDarker;
  final Function() onItemDismissSwipe;
  final Function() onItemEditModeSwipe;
  final Function(DismissDirection direction)? onItemSwipe;
  final Function() onChangeToValue;
  const DataField(
      {super.key,
      required this.model,
      required this.allValuesData,
      required this.isDarker,
      required this.onItemDismissSwipe,
      required this.onItemEditModeSwipe,
      required this.onChangeToValue,
      this.onItemSwipe});

  get text => null;

  @override
  State<DataField> createState() => _DataFieldState();
}

class _DataFieldState extends State<DataField> {
  TextEditingController textController = TextEditingController();

  List<String> allValuesForType(ReceiptObjectType type) {
    switch (type) {
      case ReceiptObjectType.product:
        return widget.allValuesData.prices;
      case ReceiptObjectType.date:
        return widget.allValuesData.dates;
      case ReceiptObjectType.info:
        return widget.allValuesData.info;
      default:
        return [];
    }
  }

  Future<bool> handleSwipe(DismissDirection direction) async {
    if (direction == DismissDirection.startToEnd) {
      return true;
    } else if (direction == DismissDirection.endToStart) {
      widget.onItemEditModeSwipe();
    }
    return false;
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

  get valueTypeMenu => Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: PopupMenuButton<String>(
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
          color: gold,
          child: const Icon(
            Icons.type_specimen,
            color: gold,
          ),
        ),
      );

  get valueRemoveButton => IconButton(
        onPressed: () => setState(() => widget.model.value = null),
        icon: const Icon(
          Icons.cancel,
          color: Color.fromARGB(162, 119, 7, 7),
        ),
      );

  get valueAddButton => IconButton(
        onPressed: () => setState(() => widget.model.value = ''),
        icon: const Icon(
          Icons.add_box,
          color: green,
        ),
      );

  get valueField => ValueField(
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

  get changeItemToValueButton => IconButton(
        onPressed: widget.onChangeToValue,
        icon: const Icon(Icons.transform, color: green),
      );

  get dataFieldContent {
    List<Widget> columnContent = [];
    Widget dataTextField = DataTextField(textController: textController);

    if (widget.model.isEditing) {
      columnContent = [
        Row(children: [Expanded(child: dataTextField), valueTypeMenu]),
        if (widget.model.value != null)
          Row(children: [Expanded(child: valueField), valueRemoveButton])
        else
          Row(children: [Expanded(child: Container()), valueAddButton]),
      ];
    } else {
      columnContent = [
        dataTextField,
        if (widget.model.value != null) valueField,
      ];
    }

    Widget dataFieldWidget = Container(
      decoration: BoxDecoration(
        color: widget.isDarker ? Colors.black.withOpacity(0.03) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: columnContent),
      ),
    );

    if (widget.model.isEditing) {
      return Row(children: [changeItemToValueButton, Expanded(child: dataFieldWidget)]);
    }

    return dataFieldWidget;
  }

  get swipableDataFieldContent => Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) => widget.onItemDismissSwipe(),
        confirmDismiss: handleSwipe,
        background: getSwipeBackground(
            Icons.highlight_remove_outlined, redTransparentGradient),
        secondaryBackground:
            getSwipeBackground(Icons.edit, transparentGoldGradient),
        child: dataFieldContent,
      );

  Widget getSwipeBackground(
          final IconData iconData, final LinearGradient gradient) =>
      Container(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0),
          child: Icon(iconData),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return swipableDataFieldContent;
  }
}
