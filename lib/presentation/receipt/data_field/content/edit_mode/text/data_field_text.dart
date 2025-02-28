import 'package:flutter/material.dart';

class DataFieldEditModeText extends StatelessWidget {
  const DataFieldEditModeText({
    super.key,
    required this.text,
    required this.textColor,
    this.fontWeight,
  });

  final String text;
  final Color textColor;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: fontWeight ?? FontWeight.w700,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
