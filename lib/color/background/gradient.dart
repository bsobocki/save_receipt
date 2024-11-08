import 'package:flutter/material.dart';

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

const LinearGradient redTransparentGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color.fromARGB(190, 126, 1, 1),
    Color.fromARGB(150, 126, 1, 1),
    Color.fromARGB(97, 126, 1, 1),
    Colors.transparent,
  ],
);


const LinearGradient transparentYellowGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.transparent,
    Color.fromARGB(85, 207, 186, 1),
    Color.fromARGB(143, 207, 186, 1),
    Color.fromARGB(227, 207, 187, 1),
  ],
);
