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

  List<Color> get _colors => [
        mainColor.moved(-80),
        mainColor,
        mainColor.moved(80),
      ];

  LinearGradient get gradient => LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight, colors: _colors);

  LinearGradient get reverseGradient => LinearGradient(
      begin: Alignment.bottomRight, end: Alignment.topLeft, colors: _colors);

  ColorScheme get colorScheme => ColorScheme(
      brightness: Brightness.dark,
      primary: mainColor,
      onPrimary: Colors.white,
      secondary: ligtherMainColor,
      onSecondary: darkerMainColor,
      error: Colors.red,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Colors.white,
      onPrimaryContainer: Colors.white,
      onTertiaryFixed: Colors.white);
}
