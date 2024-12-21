import 'package:flutter/material.dart';
import 'package:save_receipt/core/themes/styles/colors.dart';

const LinearGradient blackGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.black,
    Color.fromARGB(202, 0, 0, 0),
    Colors.black54,
    Colors.black45,
    Colors.black38,
  ],
);

const LinearGradient purpleGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color.fromARGB(255, 59, 0, 66),
    Color.fromARGB(221, 59, 0, 66),
    Color.fromARGB(120, 59, 0, 66),
    Color.fromARGB(36, 59, 0, 66),
  ],
);

LinearGradient redToTransparentGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    darkRed,
    darkRed.withOpacity(0.6),
    darkRed.withOpacity(0.2),
    Colors.transparent,
  ],
);

LinearGradient transparentToGoldGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.transparent,
    gold.withOpacity(0.2),
    gold.withOpacity(0.6),
    gold,
  ],
);

LinearGradient transparentToGreyGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    const Color.fromARGB(255, 112, 69, 69).withOpacity(0.6),
    const Color.fromARGB(255, 112, 69, 69).withOpacity(0.6),
    const Color.fromARGB(255, 112, 69, 69).withOpacity(0.6),
  ],
);
