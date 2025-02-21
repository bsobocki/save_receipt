import 'package:flutter/material.dart';

class DataTextField extends StatefulWidget {
  final Color? textColor;
  final Function(String) onChanged;
  final TextEditingController textController;

  const DataTextField({
    super.key,
    Color? textColor,
    required this.onChanged,
    required this.textController,
  }) : textColor = textColor ?? Colors.black;

  @override
  State<DataTextField> createState() => _DataTextFieldState();
}

class _DataTextFieldState extends State<DataTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 24,
        left: 8.0,
        top: 4.0,
        bottom: 0.0,
      ),
      child: TextField(
        controller: widget.textController,
        onChanged: widget.onChanged,
        style: TextStyle(
          color: widget.textColor,
          fontWeight: FontWeight.w600,
          fontSize: 14.0,
        ),
        textAlign: TextAlign.left,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          isDense: true,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
