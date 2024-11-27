import 'package:flutter/material.dart';

class DataTextField extends StatefulWidget {
  final TextEditingController textController;
  final Color? textColor;
  final bool editMode;
  final Function(String) onChanged;

  const DataTextField({
    required this.textController,
    required this.editMode,
    Color? textColor,
    super.key,
    required this.onChanged,
  }) : textColor = textColor ?? Colors.black;

  @override
  State<DataTextField> createState() => _DataTextFieldState();
}

class _DataTextFieldState extends State<DataTextField> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Padding(
        padding: const EdgeInsets.only(
          right: 24,
          left: 8.0,
          top: 8.0,
          bottom: 8.0,
        ),
        child: TextField(
          enabled: !widget.editMode,
          controller: widget.textController,
          onChanged: widget.onChanged,
          style:
              TextStyle(color: widget.textColor, fontWeight: FontWeight.w600),
          textAlign: TextAlign.left,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            isDense: true,
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
