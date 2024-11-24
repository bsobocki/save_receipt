import 'package:flutter/material.dart';
import 'package:save_receipt/color/themes/main_theme.dart';
import 'package:save_receipt/components/expendable/expandable_button.dart';

class DataFieldAddRemoveValueButton extends StatefulWidget {
  const DataFieldAddRemoveValueButton({
    super.key,
    required this.valueExists,
    required this.removeButtonColor,
    required this.addButtonColor,
    required this.onRemoveValue,
    required this.onAddValue,
  });

  final bool valueExists;
  final Color removeButtonColor;
  final Color addButtonColor;
  final VoidCallback onRemoveValue;
  final VoidCallback onAddValue;

  @override
  State<DataFieldAddRemoveValueButton> createState() =>
      _DataFeildAddRemoveValueButtonState();
}

class _DataFeildAddRemoveValueButtonState
    extends State<DataFieldAddRemoveValueButton> {
  get valueRemoveButton => ExpandableButton(
        label: "Remove Value",
        onPressed: widget.onRemoveValue,
        iconColor: widget.removeButtonColor,
        buttonColor: mainTheme.mainColor.withOpacity(0.5),
        iconData: Icons.delete_forever_sharp,
        textColor: Colors.white,
      );

  get valueAddButton => ExpandableButton(
        label: "Add Value",
        onPressed: widget.onAddValue,
        buttonColor: mainTheme.mainColor.withOpacity(0.5),
        iconColor: widget.addButtonColor,
        iconData: Icons.add,
        textColor: Colors.white,
      );

  @override
  Widget build(BuildContext context) {
    return widget.valueExists ? valueRemoveButton : valueAddButton;
  }
}
