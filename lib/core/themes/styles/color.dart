
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