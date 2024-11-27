import 'package:flutter/material.dart';
import 'package:save_receipt/color/themes/main_theme.dart';

class DataFieldColorScheme {
  late final Color textColor;
  late final Color backgroundColor;
  late final Color redButtonColor;
  late final Color goldButtonColor;
  late final Color greenButtonColor;
  late final Color greyButtonColor;

  DataFieldColorScheme(bool isDarker, bool editMode) {
    if (editMode) {
      backgroundColor = mainTheme.ligtherMainColor;
      textColor = Colors.white.withOpacity(0.6);
    } else {
      textColor = Colors.black;
      backgroundColor = mainTheme.mainColor.withOpacity(isDarker ? 0.04 : 0.0);
    }
    redButtonColor = const Color.fromARGB(255, 211, 77, 77);
    goldButtonColor = const Color.fromARGB(255, 172, 134, 23);
    greenButtonColor = const Color.fromARGB(255, 77, 148, 80);
    greyButtonColor = const Color.fromARGB(255, 140, 145, 140);
  }
}
