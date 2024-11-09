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

LinearGradient redTransparentGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    red,
    red.withOpacity(0.6),
    red.withOpacity(0.2),
    Colors.transparent,
  ],
);

LinearGradient transparentGoldGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.transparent,
    gold.withOpacity(0.2),
    gold.withOpacity(0.6),
    gold,
  ],
);
