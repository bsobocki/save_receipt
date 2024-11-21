import 'package:flutter/material.dart';
import 'package:save_receipt/screen/receipt_data/components/expandable_button.dart';

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
  final Function() onRemoveValue;
  final Function() onAddValue;

  @override
  State<DataFieldAddRemoveValueButton> createState() =>
      _DataFeildAddRemoveValueButtonState();
}

class _DataFeildAddRemoveValueButtonState
    extends State<DataFieldAddRemoveValueButton> {

  get valueRemoveButton => ExpandableButton(
        label: "Remove Value",
        onPressed: widget.onRemoveValue,
        buttonColor: widget.removeButtonColor,
        iconData: Icons.delete_forever_sharp,
        iconColor: Colors.white,
        textColor: Colors.white,
      );
  
  get valueAddButton => ExpandableButton(
        label: "Add Value",
        onPressed: widget.onAddValue,
        buttonColor: widget.addButtonColor,
        iconData: Icons.add,
        iconColor: Colors.white,
        textColor: Colors.white,
      );

  @override
  Widget build(BuildContext context) {
    return widget.valueExists ? valueRemoveButton : valueAddButton;
  }
}
