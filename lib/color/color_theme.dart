import 'package:flutter/material.dart';

extension ColorBrightness on Color {
  Color brighter([double factor = 0.3]) {
    HSLColor hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness + factor).clamp(0.0, 1.0)).toColor();
  }
  
  Color darker([double factor = 0.3]) {
    HSLColor hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness - factor).clamp(0.0, 1.0)).toColor();
  }

  Color lighter([double amount = 0.1]) {
    HSLColor hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }
}

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
