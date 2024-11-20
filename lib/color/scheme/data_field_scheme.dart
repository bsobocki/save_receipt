import 'package:flutter/material.dart';
import 'package:save_receipt/color/colors.dart';

class DataFieldColorScheme {
  late final Color textColor;
  late final Color backgroundColor;
  late final Color redButtonColor;
  late final Color goldButtonColor;
  late final Color greenButtonColor;

  DataFieldColorScheme(bool isDarker, bool editMode) {
    if (editMode) {
      backgroundColor = Colors.black.withOpacity(0.6);
      textColor = Colors.white.withOpacity(0.6);
    } else {
      textColor = Colors.black;
      backgroundColor = Colors.black.withOpacity(isDarker ? 0.04 : 0.0);
    }
    redButtonColor = Colors.red[800]!;
    goldButtonColor = gold;
    greenButtonColor = Colors.green[700]!;
  }
}
