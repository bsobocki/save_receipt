import 'package:flutter/material.dart';

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
  get valueRemoveButton => CircleAvatar(
        backgroundColor: widget.removeButtonColor,
        child: IconButton(
          onPressed: widget.onRemoveValue,
          icon: const Icon(Icons.delete_forever_sharp),
          color: Colors.white,
        ),
      );

  get valueAddButton => CircleAvatar(
        backgroundColor: widget.addButtonColor,
        child: IconButton(
          onPressed: widget.onAddValue,
          icon: const Icon(Icons.add),
          color: Colors.white,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return widget.valueExists ? valueRemoveButton : valueAddButton;
  }
}
