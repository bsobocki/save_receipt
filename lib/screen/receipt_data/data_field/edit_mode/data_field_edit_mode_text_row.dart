import 'package:flutter/material.dart';
import 'package:save_receipt/color/scheme/data_field_scheme.dart';
import 'package:save_receipt/screen/receipt_data/data_field/edit_mode/options/label/expandable_text_options.dart';
import 'package:save_receipt/screen/receipt_data/data_field/edit_mode/text/value_text.dart';
import 'package:save_receipt/source/data/structures/data_field.dart';

class DataFieldEditModeTextRow extends StatefulWidget {
  const DataFieldEditModeTextRow({
    super.key,
    required this.colorScheme,
    required this.model,
    required this.onFieldToValueChanged,
  });

  final DataFieldColorScheme colorScheme;
  final DataFieldModel model;
  final VoidCallback onFieldToValueChanged;

  @override
  State<DataFieldEditModeTextRow> createState() =>
      _DataFieldEditModeTextRowState();
}

class _DataFieldEditModeTextRowState extends State<DataFieldEditModeTextRow> {
  bool expandedOptions = false;

  Widget expandableOptionsButtons(BoxConstraints constraints) =>
      DataFieldTextOptions(
        key: UniqueKey(),
        constraints: constraints,
        onFieldToValueChanged: widget.onFieldToValueChanged,
        isExpanded: expandedOptions,
        onChangeToValue: widget.onFieldToValueChanged,
        onCollapse: () {},
      );

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      if (!expandedOptions)
      Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: DataFieldValueText(
          fontWeight: FontWeight.bold,
            text: widget.model.text,
            textColor: widget.colorScheme.textColor),
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
