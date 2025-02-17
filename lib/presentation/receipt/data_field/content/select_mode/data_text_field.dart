import 'package:flutter/material.dart';

class SelectModeDataTextField extends StatelessWidget {
  final String text;
  final Color? textColor;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final double? fontSize;

  const SelectModeDataTextField({
    super.key,
    required this.text,
    this.textAlign,
    this.textColor,
    this.fontWeight,
    this.fontSize,
  });

  Widget get placeholder => Expanded(child: Container());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 32.0,
        left: 22.0,
        top: 4.0,
        bottom: 4.0,
      ),
      child: Container(
        alignment: textAlign == TextAlign.right
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: textColor,
            fontWeight: fontWeight,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
