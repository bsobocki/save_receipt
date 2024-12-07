import 'package:flutter/material.dart';
import 'package:save_receipt/presentation/common/widgets/expendable/expandable_button.dart';

class DataFieldAddRemoveValueButton extends StatefulWidget {
  const DataFieldAddRemoveValueButton({
    super.key,
    required this.valueExists,
    required this.removeButtonForegroundColor,
    required this.addButtonForegroundColor,
    required this.onRemoveValue,
    required this.onAddValue,
    required this.buttonColor,
  });

  final bool valueExists;
  final Color removeButtonForegroundColor;
  final Color addButtonForegroundColor;
  final VoidCallback onRemoveValue;
  final VoidCallback onAddValue;
  final Color buttonColor;

  @override
  State<DataFieldAddRemoveValueButton> createState() =>
      _DataFeildAddRemoveValueButtonState();
}

class _DataFeildAddRemoveValueButtonState
    extends State<DataFieldAddRemoveValueButton> {
  get valueRemoveButton => ExpandableButton(
        label: "Remove Value",
        onPressed: widget.onRemoveValue,
        iconColor: widget.removeButtonForegroundColor,
        buttonColor: widget.buttonColor,
        iconData: Icons.delete_forever_sharp,
        textColor: Colors.white,
      );

  get valueAddButton => ExpandableButton(
        label: "Add Value",
        onPressed: widget.onAddValue,
        buttonColor: widget.buttonColor,
        iconColor: widget.addButtonForegroundColor,
        iconData: Icons.add,
        textColor: Colors.white,
      );

  @override
  Widget build(BuildContext context) {
    return widget.valueExists ? valueRemoveButton : valueAddButton;
  }
}
