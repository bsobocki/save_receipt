import 'package:flutter/material.dart';

class DataTextField extends StatefulWidget {
  final TextEditingController textController;
  final Color? textColor;
  final bool editMode;

  const DataTextField({
    required this.textController,
    required this.editMode,
    Color? textColor,
    super.key,
  }) : textColor = textColor ?? Colors.black;

  @override
  State<DataTextField> createState() => _DataTextFieldState();
}

class _DataTextFieldState extends State<DataTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: !widget.editMode,
      controller: widget.textController,
      style: TextStyle(color: widget.textColor, fontWeight: FontWeight.w600),
      textAlign: TextAlign.left,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        isDense: true,
        border: InputBorder.none,
      ),
    );
  }
}
