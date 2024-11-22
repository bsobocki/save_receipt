import 'package:flutter/material.dart';
import 'package:save_receipt/color/scheme/data_field_scheme.dart';
import 'package:save_receipt/screen/receipt_data/components/expandable_button.dart';
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

  get buttonList {
    List<Widget> buttons = [
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
      buttons += [
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

    return buttons;
  }

  get expandingButton => IconButton(
        icon: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
            child: Icon(
              isExpanded
                  ? Icons.arrow_right_outlined
                  : Icons.arrow_left_outlined,
              color: Colors.white,
            )),
        onPressed: () {
          setState(() {
            isExpanded = !isExpanded;
          });
        },
      );

  Widget optionPanel(double expandedOptionsWidth) => AnimatedContainer(
        width: expandedOptionsWidth,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: buttonList,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    double expandedOptionPanelWidth =
        isExpanded ? widget.constraints.maxWidth - iconButtonSize : 0.0;
    double widgetWidth =
        isExpanded ? widget.constraints.maxWidth : iconButtonSize;

    return Container(
      constraints: BoxConstraints(maxWidth: widgetWidth),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          expandingButton,
          optionPanel(expandedOptionPanelWidth),
        ],
      ),
    );
  }
}
