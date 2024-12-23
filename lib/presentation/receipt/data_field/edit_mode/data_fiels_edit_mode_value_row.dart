import 'package:flutter/material.dart';
import 'package:save_receipt/core/themes/schemes/data_field_scheme.dart';
import 'package:save_receipt/presentation/receipt/data_field/edit_mode/options/value/expandable_value_options.dart';
import 'package:save_receipt/presentation/receipt/data_field/edit_mode/text/value_text.dart';
import 'package:save_receipt/domain/entities/receipt_object.dart';

class DataFieldEditModeValueRow extends StatefulWidget {
  const DataFieldEditModeValueRow({
    super.key,
    required this.colorScheme,
    required this.model,
    required this.onValueToFieldChange,
    required this.onValueTypeChanged,
  });

  final DataFieldColorScheme colorScheme;
  final ReceiptObjectModel model;
  final Function() onValueToFieldChange;
  final Function(ReceiptObjectModelType) onValueTypeChanged;

  @override
  State<DataFieldEditModeValueRow> createState() =>
      _DataFieldEditModeValueRowState();
}

class _DataFieldEditModeValueRowState extends State<DataFieldEditModeValueRow> {
  bool expandedOptions = false;

  Widget expandableOptionsButtons(BoxConstraints constraints) =>
      ExpandableValueOptions(
        key: UniqueKey(),
        constraints: constraints,
        colors: widget.colorScheme,
        onRemoveValue: () => setState(() {
          widget.model.value = null;
          expandedOptions = true;
        }),
        onAddValue: () => setState(() {
          widget.model.value = '<no value>';
          expandedOptions = true;
        }),
        onValueTypeChanged: widget.onValueTypeChanged,
        onCollapse: () => setState(() {
          expandedOptions = false;
        }),
        valueExists: widget.model.value != null,
        initType: widget.model.type,
        onValueToFieldChange: widget.onValueToFieldChange,
        isExpanded: expandedOptions,
      );

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) =>
              expandableOptionsButtons(constraints),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: DataFieldValueText(
            key: UniqueKey(),
            fontWeight: FontWeight.normal,
            text: widget.model.value ?? '',
            textColor: widget.colorScheme.textColor),
      ),
    ]);
  }
}
