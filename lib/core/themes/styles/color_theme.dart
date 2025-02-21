import 'package:flutter/material.dart';
import 'package:save_receipt/core/themes/styles/color.dart';

class ColorTheme {
  static const int _lighter = 40;
  static const int _darker = -40;

  Color _mainColor;

  void setMainColor(Color newColor) => _mainColor = newColor;

  Color get mainColor => _mainColor;
  Color get ligtherMainColor => _mainColor.moved(_lighter);
  Color get extraLightMainColor => _mainColor.moved(_lighter * 2);
  Color get darkerMainColor => _mainColor.moved(_darker);
  Color get extraDarkMainColor => _mainColor.moved(_darker * 2);
  Color get unselectedColor => extraLightMainColor;

  ColorTheme(Color mainColor) : _mainColor = mainColor;

  List<Color> get _colors => [
        mainColor.moved(-100),
        mainColor,
        mainColor.moved(100),
      ];

  LinearGradient get gradient => LinearGradient(
      begin: Alignment.topLeft, end: Alignment.bottomRight, colors: _colors);

  LinearGradient get reverseGradient => LinearGradient(
      begin: Alignment.bottomRight, end: Alignment.topLeft, colors: _colors);

  List<Color> get _lighterColors => [
        mainColor,
        mainColor.moved(100),
        mainColor.moved(200),
      ];

  LinearGradient get lighterGradient => LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: _lighterColors);

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
