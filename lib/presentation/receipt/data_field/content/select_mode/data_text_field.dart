import 'package:flutter/material.dart';

class SelectModeDataTextField extends StatelessWidget {
  final String text;
  final Color? textColor;
  final TextAlign textAlign;

  const SelectModeDataTextField({
    super.key,
    required this.text,
    required this.textAlign,
    Color? textColor,
  }) : textColor = textColor ?? Colors.black;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 24,
        left: 8.0,
        top: 4.0,
        bottom: 0.0,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 14.0,
        ),
        textAlign: textAlign,
      ),
    );
  }
}
