import 'package:flutter/material.dart';

class DataFieldValueText extends StatelessWidget {
  const DataFieldValueText({
    super.key,
    required this.text,
    required this.textColor,
  });

  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 80),
      child: Text(
        text,
        style: TextStyle(color: textColor),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
