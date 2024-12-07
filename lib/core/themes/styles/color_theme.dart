import 'package:flutter/material.dart';

extension ColorBrightness on Color {
  Color moved([int value = 20]) {
    int r = red + value;
    r = r > 255 ? 255 : r;
    r = r < 0 ? 0 : r;

    int g = green + value;
    g = g > 255 ? 255 : g;
    g = g < 0 ? 0 : g;

    int b = blue + value;
    b = b > 255 ? 255 : b;
    b = b < 0 ? 0 : b;
    return Color.fromARGB(alpha, r, g, b);
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
            mainColor.moved(-60),
            mainColor,
            mainColor.moved(40),
            mainColor.moved(100),
            mainColor.moved(160),
          ]);
}
