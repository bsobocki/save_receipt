import 'package:flutter/material.dart';
import 'package:save_receipt/color/scheme/data_field_scheme.dart';
import 'package:save_receipt/screen/receipt_data/data_field/edit_mode/options/value/value_options.dart';
import 'package:save_receipt/screen/receipt_data/data_field/edit_mode/text/value_text.dart';
import 'package:save_receipt/source/data/structures/data_field.dart';
import 'package:save_receipt/source/data/structures/receipt.dart';

class DataFieldEditModeValueRow extends StatefulWidget {
  const DataFieldEditModeValueRow({
    super.key,
    required this.colorScheme,
    required this.model,
    required this.onValueToFieldChange,
  });

  final DataFieldColorScheme colorScheme;
  final DataFieldModel model;
  final Function() onValueToFieldChange;

  @override
  State<DataFieldEditModeValueRow> createState() =>
      _DataFieldEditModeValueRowState();
}

class _DataFieldEditModeValueRowState extends State<DataFieldEditModeValueRow> {
  Widget expandableOptionsButtons(BoxConstraints constraints) =>
      ExpandableValueOptions(
        constraints: constraints,
        colors: widget.colorScheme,
        onRemoveValue: () => setState(() => widget.model.value = null),
        onAddValue: () => setState(() => widget.model.value = '<no value>'),
        onValueTypeChange: (ReceiptObjectType value) =>
            widget.model.type = value,
        onCollapse: () => setState(() {}),
        valueExists: widget.model.value != null,
        initType: widget.model.type,
        onValueToFieldChange: widget.onValueToFieldChange,
      );

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      DataFieldValueText(
          text: widget.model.value ?? '',
          textColor: widget.colorScheme.textColor),
      Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) =>
              expandableOptionsButtons(constraints),
        ),
      ),
    ]);
  }
}
