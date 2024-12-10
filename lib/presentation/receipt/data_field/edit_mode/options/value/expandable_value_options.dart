import 'package:flutter/material.dart';
import 'package:save_receipt/core/themes/schemes/data_field_scheme.dart';
import 'package:save_receipt/core/themes/main_theme.dart';
import 'package:save_receipt/domain/entities/data_field.dart';
import 'package:save_receipt/presentation/common/widgets/expendable/expandable_button.dart';
import 'package:save_receipt/presentation/common/widgets/expendable/expandable_option_panel.dart';
import 'package:save_receipt/presentation/receipt/data_field/edit_mode/options/value/buttons/add_remove_value_button.dart';
import 'package:save_receipt/presentation/receipt/data_field/edit_mode/options/value/buttons/value_type_menu.dart';

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
  final Function(ReceiptObjectModelType) onValueTypeChange;
  final ReceiptObjectModelType initType;
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
        removeButtonForegroundColor: widget.colors.redButtonColor,
        addButtonForegroundColor: widget.colors.greenButtonColor,
        onRemoveValue: widget.onRemoveValue,
        onAddValue: widget.onAddValue,
        buttonColor: mainTheme.mainColor,
      ),
      separator,
      DataFieldValueTypeMenu(
        color: widget.colors.goldButtonColor,
        type: widget.initType,
        onSelected: widget.onValueTypeChange,
        buttonColor: mainTheme.mainColor,
      ),
      separator,
    ];

    if (widget.valueExists) {
      optionButtons += [
        ExpandableButton(
          label: 'Value As New Item',
          textColor: Colors.white,
          iconData: Icons.swap_horiz_outlined,
          iconColor: widget.colors.greyButtonColor,
          buttonColor: mainTheme.mainColor,
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
      alignment: MainAxisAlignment.start,
      options: options,
      onCollapse: widget.onCollapse,
      constraints: widget.constraints,
      isExpanded: isExpanded,
      iconColor: mainTheme.mainColor,
      buttonColor: Colors.white,
    );
  }
}
