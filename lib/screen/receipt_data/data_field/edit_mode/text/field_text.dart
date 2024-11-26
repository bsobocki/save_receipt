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
    return Container(
      constraints: const BoxConstraints(maxWidth: 150),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
