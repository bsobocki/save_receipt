import 'package:flutter/material.dart';

class DataFieldEditModeText extends StatelessWidget {
  const DataFieldEditModeText({
    super.key,
    required this.text,
    required this.textColor,
  });
  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
        Expanded(child: Container()),
      ],
    );
  }
}
