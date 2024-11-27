import 'package:flutter/material.dart';

extension ColorBrightness on Color {
  Color moved([int value = 20]) {
    return Color.fromARGB(alpha, red + value, green + value, blue + value);
  }
}

class ColorTheme {
  final Color mainColor;
  late final Color ligtherMainColor;
  late final Color extraLightMainColor;
  late final Color darkerMainColor;
  late final Color extraDarkMainColor;
  late final Color unselectedColor;

  ColorTheme({
    required this.mainColor,
  }) {
    const int lighter = 40;
    const int darker = -40;

    ligtherMainColor = mainColor.moved(lighter);
    extraLightMainColor = ligtherMainColor.moved(lighter);

    darkerMainColor = mainColor.moved(darker);
    extraDarkMainColor = darkerMainColor.moved(darker);

    unselectedColor = extraLightMainColor;
  }

  LinearGradient get gradient => LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            mainColor,
            mainColor.withOpacity(0.9),
            mainColor.withOpacity(0.8),
            mainColor.withOpacity(0.6),
            mainColor.withOpacity(0.4),
          ]);
}
