import 'package:flutter/material.dart';
import 'package:save_receipt/color/colors.dart';
import 'package:save_receipt/color/gradient.dart';
import 'package:save_receipt/color/scheme/data_field_scheme.dart';
import 'package:save_receipt/screen/receipt_data/data_field/options/options_buttons.dart';
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
  late final DataFieldColorScheme colorScheme;

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
    colorScheme = DataFieldColorScheme(widget.isDarker, widget.model.isEditing);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  get valueField => ValueField(
        textColor: colorScheme.textColor,
        editMode: widget.model.isEditing,
        initValue: widget.model.value ?? '',
        values: allValuesForType(widget.model.type),
        onSelected: (value) {
          setState(() {
            if (value != null) {
              widget.model.value = value;
            }
          });
        },
      );

  get changeItemToValueButton => IconButton(
        onPressed: widget.onChangeToValue,
        icon: const Icon(Icons.transform, color: darkGreen),
      );

  Widget expandableOptionsButtons(BoxConstraints constraints) =>
      ExpandableOptionsButtons(
        constraints: constraints,
        model: widget.model,
        colors: colorScheme,
        onRemoveValue: () => setState(() => widget.model.value = null),
        onAddValue: () => setState(() => widget.model.value = '<no value>'),
        onValueTypeChange: (ReceiptObjectType value) {
          widget.model.type = value;
        },
        onCollapse: () => setState(() {}),
      );

  get dataFieldContent {
    Widget dataTextField = DataTextField(
      editMode: widget.model.isEditing,
      textColor: colorScheme.textColor,
      textController: textController,
    );
    List<Widget> columnContent = [dataTextField];

    if (widget.model.isEditing) {
      columnContent.add(
        Row(children: [
          valueField,
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) =>
                  expandableOptionsButtons(constraints),
            ),
          ),
        ]),
      );
    } else if (widget.model.value != null) {
      columnContent.add(valueField);
    }

    Widget dataFieldWidget = Container(
      color: colorScheme.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: columnContent),
      ),
    );

    if (widget.model.isEditing) {
      return Row(
        children: [
          changeItemToValueButton,
          Expanded(
            child: dataFieldWidget,
          )
        ],
      );
    }

    return dataFieldWidget;
  }

  get swipableDataFieldContent => Dismissible(
        key: UniqueKey(),
        onDismissed: (direction) => widget.onItemDismissSwipe(),
        confirmDismiss: handleSwipe,
        background: getFieldSwipeBackground(
            Icons.close, redToTransparentGradient, Alignment.centerLeft),
        secondaryBackground: getFieldSwipeBackground(
            widget.model.isEditing ? Icons.edit_off : Icons.edit,
            transparentToGoldGradient,
            Alignment.centerRight),
        child: dataFieldContent,
      );

  Widget getFieldSwipeBackground(final IconData iconData,
          final LinearGradient gradient, Alignment alignment) =>
      Container(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 8.0,
            bottom: 8.0,
          ),
          child: Icon(iconData),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return swipableDataFieldContent;
  }
}
