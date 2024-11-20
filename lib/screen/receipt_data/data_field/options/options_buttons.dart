import 'package:flutter/material.dart';
import 'package:save_receipt/color/scheme/data_field_scheme.dart';
import 'package:save_receipt/screen/receipt_data/data_field/options/add_remove_value_button.dart';
import 'package:save_receipt/screen/receipt_data/data_field/options/value_type_menu.dart';
import 'package:save_receipt/source/data/structures/data_field.dart';
import 'package:save_receipt/source/data/structures/receipt.dart';

const double iconButtonSize = 48;

class ExpandableOptionsButtons extends StatefulWidget {
  const ExpandableOptionsButtons({
    super.key,
    required this.colors,
    required this.onRemoveValue,
    required this.onAddValue,
    required this.onCollapse,
    required this.model,
    required this.onValueTypeChange,
    required this.constraints,
  });

  final DataFieldColorScheme colors;
  final Function() onRemoveValue;
  final Function() onAddValue;
  final Function() onCollapse;
  final Function(ReceiptObjectType) onValueTypeChange;
  final DataFieldModel model;
  final BoxConstraints constraints;

  @override
  State<ExpandableOptionsButtons> createState() =>
      _ExpandableOptionsButtonsState();
}

class _ExpandableOptionsButtonsState extends State<ExpandableOptionsButtons> {
  bool isExpanded = false;

  get separator {
    //return Expanded(child: Container());
    return SizedBox(width: 16);
  }

  @override
  Widget build(BuildContext context) {
    final double width =
        isExpanded ? widget.constraints.maxWidth - iconButtonSize : 0.0;

    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
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
          ),
          AnimatedContainer(
            width: width,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  separator,
                  DataFieldAddRemoveValueButton(
                    value: widget.model.value,
                    removeButtonColor: widget.colors.redButtonColor,
                    addButtonColor: widget.colors.greenButtonColor,
                    onRemoveValue: widget.onRemoveValue,
                    onAddValue: widget.onAddValue,
                  ),
                  separator,
                  DataFieldValueTypeMenu(
                    color: widget.colors.goldButtonColor,
                    type: widget.model.type,
                    onSelected: (value) => setState(() => widget.onValueTypeChange(value)),
                  ),
                  separator,
                  CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                    child: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                  separator,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
