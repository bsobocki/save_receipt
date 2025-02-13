import 'package:flutter/material.dart';

class SelectModeDataTextField extends StatelessWidget {
  final String text;
  final Color? textColor;
  final TextAlign textAlign;

  const SelectModeDataTextField({
    super.key,
    required this.text,
    required this.textAlign,
    this.textColor,
  });

  Widget get placeholder => Expanded(child: Container());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 22.0,
        left: 22.0,
        top: 4.0,
        bottom: 4.0,
      ),
      child: Row(
        children: [
          if (textAlign == TextAlign.right) placeholder,
          Expanded(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
            ),
          ),
          if (textAlign == TextAlign.left) placeholder
        ],
      ),
    );
  }
}
