import 'package:flutter/material.dart';
import 'package:save_receipt/color/scheme/data_field_scheme.dart';
import 'package:save_receipt/screen/receipt_data/data_field/edit_mode/options/options_buttons.dart';
import 'package:save_receipt/source/data/structures/data_field.dart';
import 'package:save_receipt/source/data/structures/receipt.dart';

class DataFieldEditModeValueRow extends StatefulWidget {
  const DataFieldEditModeValueRow({
    super.key,
    required this.colorScheme,
    required this.model,
  });

  final DataFieldColorScheme colorScheme;
  final DataFieldModel model;

  @override
  State<DataFieldEditModeValueRow> createState() =>
      _DataFieldEditModeValueRowState();
}

class _DataFieldEditModeValueRowState extends State<DataFieldEditModeValueRow> {
  Widget expandableOptionsButtons(BoxConstraints constraints) =>
      ExpandableOptionsButtons(
        constraints: constraints,
        colors: widget.colorScheme,
        onRemoveValue: () => setState(() => widget.model.value = null),
        onAddValue: () => setState(() => widget.model.value = '<no value>'),
        onValueTypeChange: (ReceiptObjectType value) =>
            widget.model.type = value,
        onCollapse: () => setState(() {}),
        valueExists: widget.model.value != null,
        initType: widget.model.type,
      );

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
