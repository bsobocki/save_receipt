import 'package:flutter/material.dart';

class ColorTheme {
  final Color mainColor;

  ColorTheme({required this.mainColor});

  LinearGradient get gradient => LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            mainColor,
            mainColor.withOpacity(0.8),
            mainColor.withOpacity(0.6),
            mainColor.withOpacity(0.4),
          ]);
}
