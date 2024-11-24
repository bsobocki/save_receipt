import 'package:flutter/material.dart';
import 'package:save_receipt/color/scheme/data_field_scheme.dart';
import 'package:save_receipt/color/themes/main_theme.dart';
import 'package:save_receipt/components/expandable_button.dart';
import 'package:save_receipt/components/expandable_option_panel.dart';
import 'package:save_receipt/screen/receipt_data/data_field/edit_mode/options/value/buttons/add_remove_value_button.dart';
import 'package:save_receipt/screen/receipt_data/data_field/edit_mode/options/value/buttons/value_type_menu.dart';
import 'package:save_receipt/source/data/structures/receipt.dart';

const double iconButtonSize = 48;

class ExpandableValueOptions extends StatefulWidget {
  const ExpandableValueOptions({
    super.key,
    required this.colors,
    required this.onRemoveValue,
    required this.onAddValue,
    required this.onCollapse,
    required this.valueExists,
    required this.onValueTypeChange,
    required this.constraints,
    required this.initType,
    required this.onValueToFieldChange,
    this.isExpanded = false,
  });

  final DataFieldColorScheme colors;
  final VoidCallback onRemoveValue;
  final VoidCallback onAddValue;
  final VoidCallback onCollapse;
  final VoidCallback onValueToFieldChange;
  final Function(ReceiptObjectType) onValueTypeChange;
  final ReceiptObjectType initType;
  final BoxConstraints constraints;
  final bool valueExists;
  final bool isExpanded;

  @override
  State<ExpandableValueOptions> createState() => _ExpandableValueOptionsState();
}

class _ExpandableValueOptionsState extends State<ExpandableValueOptions> {
  late bool isExpanded;
  get separator => const SizedBox(width: 16);

  @override
  void initState() {
    super.initState();
    isExpanded = widget.isExpanded;
  }

  get options {
    List<Widget> optionButtons = [
      separator,
      DataFieldAddRemoveValueButton(
        valueExists: widget.valueExists,
        removeButtonColor: widget.colors.redButtonColor,
        addButtonColor: widget.colors.greenButtonColor,
        onRemoveValue: widget.onRemoveValue,
        onAddValue: widget.onAddValue,
      ),
      separator,
      DataFieldValueTypeMenu(
        color: widget.colors.goldButtonColor,
        type: widget.initType,
        onSelected: widget.onValueTypeChange,
      ),
      separator,
    ];

    if (widget.valueExists) {
      optionButtons += [
        ExpandableButton(
          label: 'Value As New Item',
          buttonColor: Colors.blueGrey,
          iconData: Icons.swap_horiz_outlined,
          iconColor: Colors.white,
          textColor: Colors.white,
          onPressed: widget.onValueToFieldChange,
        ),
        separator,
      ];
    }

    return optionButtons;
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableOptionsPanel(
        options: options,
        onCollapse: widget.onCollapse,
        constraints: widget.constraints,
        isExpanded: isExpanded,
        iconColor: mainTheme.mainColor,
        buttonColor: Colors.white,);
  }
}
