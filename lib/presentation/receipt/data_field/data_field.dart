import 'package:flutter/material.dart';
import 'package:save_receipt/core/themes/gradients/main_gradients.dart';
import 'package:save_receipt/core/themes/schemes/data_field_scheme.dart';
import 'package:save_receipt/domain/entities/all_values.dart';
import 'package:save_receipt/presentation/receipt/data_field/edit_mode/data_field_edit_mode_label_row.dart';
import 'package:save_receipt/presentation/receipt/data_field/edit_mode/data_fiels_edit_mode_value_row.dart';
import 'package:save_receipt/presentation/receipt/data_field/main_view/label_field.dart';
import 'package:save_receipt/presentation/receipt/data_field/main_view/value_field.dart';
import 'package:save_receipt/domain/entities/data_field.dart';

class DataField extends StatefulWidget {
  final ReceiptObjectModel model;
  final AllValuesModel allValuesData;
  final bool isDarker;
  final Function() onItemDismissSwipe;
  final Function() onItemEditModeSwipe;
  final Function(DismissDirection direction)? onItemSwipe;
  final Function() onChangeToValue;
  final Function() onValueToFieldChange;
  const DataField(
      {super.key,
      required this.model,
      required this.allValuesData,
      required this.isDarker,
      required this.onItemDismissSwipe,
      required this.onItemEditModeSwipe,
      required this.onChangeToValue,
      this.onItemSwipe,
      required this.onValueToFieldChange});

  get text => null;

  @override
  State<DataField> createState() => _DataFieldState();
}

class _DataFieldState extends State<DataField> {
  TextEditingController textController = TextEditingController();
  late final DataFieldColorScheme colorScheme;

  List<String> allValuesForType(ReceiptObjectModelType type) {
    switch (type) {
      case ReceiptObjectModelType.product:
        return widget.allValuesData.prices;
      case ReceiptObjectModelType.date:
        return widget.allValuesData.dates;
      case ReceiptObjectModelType.info:
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
      initValue: widget.model.value ?? '',
      values: allValuesForType(widget.model.type),
      onValueChanged: (String? value) => widget.model.value = value);

  get dataFieldContent {
    List<Widget> columnContent = [];

    if (widget.model.isEditing) {
      columnContent = [
        DataFieldEditModeTextRow(
            colorScheme: colorScheme,
            model: widget.model,
            onFieldToValueChanged: widget.onChangeToValue),
        DataFieldEditModeValueRow(
          model: widget.model,
          colorScheme: colorScheme,
          onValueToFieldChange: widget.onValueToFieldChange,
        ),
      ];
    } else {
      columnContent = [
        DataTextField(
          editMode: widget.model.isEditing,
          textColor: colorScheme.textColor,
          textController: textController,
          onChanged: (String value) => widget.model.text = value,
        ),
        if (widget.model.value != null) valueField,
      ];
    }

    Widget dataFieldWidget = Container(
      color: colorScheme.backgroundColor,
      child: Column(children: columnContent),
    );

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
