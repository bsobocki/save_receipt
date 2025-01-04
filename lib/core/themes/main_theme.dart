import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:save_receipt/core/themes/styles/color_theme.dart';

class ThemeController extends GetxController {
static const Color _defaultColor = Color.fromARGB(255, 87, 6, 6);

  late Rx<ColorTheme> _theme = ColorTheme(_defaultColor).obs;

  final List<Color> availableColors = [
    _defaultColor,
    const Color.fromARGB(255, 6, 61, 87),
    const Color.fromARGB(255, 6, 87, 6),
    const Color.fromARGB(255, 87, 65, 6),
    const Color.fromARGB(255, 41, 6, 87),
  ];

  ThemeProvider(){}

  ColorTheme get theme => _theme.value;

  void changeMainColor(Color newColor) {
    _theme = ColorTheme(newColor).obs;
  }
}
