import 'package:flutter/material.dart';

class DataFieldValueText extends StatelessWidget {
  const DataFieldValueText({
    super.key,
    required this.text,
    required this.textColor,
    required this.fontWeight,
  });

  final String text;
  final Color textColor;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 80),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: fontWeight),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
