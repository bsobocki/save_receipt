import 'package:flutter/material.dart';
import 'package:save_receipt/presentation/receipt/components/options/value/expandable_value_options.dart';
import 'package:save_receipt/presentation/receipt/data_field/content/edit_mode/text/data_field_text.dart';
import 'package:save_receipt/domain/entities/receipt_object.dart';

class DataFieldEditModeValueRow extends StatefulWidget {
  const DataFieldEditModeValueRow({
    super.key,
    required this.model,
    required this.textColor,
    this.onValueToFieldChanged,
    this.onValueStateChanged,
    this.onValueTypeChanged,
  });

  final ReceiptObjectModel model;
  final Color textColor;
  final VoidCallback? onValueToFieldChanged;
  final VoidCallback? onValueStateChanged;
  final Function(ReceiptObjectModelType)? onValueTypeChanged;

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
        onRemoveValue: widget.model.type == ReceiptObjectModelType.product
            ? null
            : () => setState(() {
                  widget.model.value = null;
                  expandedOptions = true;
                  widget.onValueStateChanged?.call();
                }),
        onAddValue: () => setState(() {
          widget.model.value = '<no value>';
          expandedOptions = true;
          widget.onValueStateChanged?.call();
        }),
        onValueTypeChanged: widget.onValueTypeChanged,
        onCollapse: () => setState(() {
          expandedOptions = false;
        }),
        valueExists: widget.model.value != null,
        initType: widget.model.type,
        onValueToFieldChange: widget.onValueToFieldChanged,
        isExpanded: expandedOptions,
      );

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: DataFieldEditModeText(
          key: UniqueKey(),
          fontWeight: FontWeight.normal,
          text: widget.model.value ?? '',
          textColor: widget.textColor,
        ),
      ),
      Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) =>
              expandableOptionsButtons(constraints),
        ),
      ),
    ]);
  }
}
