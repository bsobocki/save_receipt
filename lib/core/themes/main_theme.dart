import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/styles/color_theme.dart';

class ThemeController extends GetxController {
static const Color _defaultColor = Color.fromARGB(255, 107, 7, 7);

  late Rx<ColorTheme> _theme = ColorTheme(_defaultColor).obs;

  final List<Color> availableColors = [
    _defaultColor,
    const Color.fromARGB(255, 7, 74, 105),
    const Color.fromARGB(255, 9, 107, 7),
    const Color.fromARGB(255, 109, 82, 7),
    const Color.fromARGB(255, 41, 6, 87),
    const Color.fromARGB(255, 11, 168, 76),
    const Color.fromARGB(255, 204, 135, 7),
    const Color.fromARGB(255, 158, 10, 10),
    const Color.fromARGB(255, 231, 37, 86),
  ];
  
  ColorTheme get theme => _theme.value;

  void changeMainColor(Color newColor) {
    _theme.value = ColorTheme(newColor);
  }
}
