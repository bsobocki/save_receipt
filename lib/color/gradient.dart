import 'package:flutter/material.dart';
import 'package:save_receipt/color/colors.dart';

const LinearGradient mainGradient = LinearGradient(
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
