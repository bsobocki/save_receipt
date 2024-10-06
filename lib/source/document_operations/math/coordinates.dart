import 'dart:math';
import 'dart:ui';

class VerticalMargin {
  late final double top;
  late final double bottom;

  VerticalMargin({required this.top, required this.bottom});

  inMargin(final double y) => top <= y && y <= bottom;

  @override
  String toString() => '{top: $top, bottom: $bottom}';

  VerticalMargin.calc(final double rotate, final Offset a, final double x) {
    double angle = rotate * (pi / 180);
    double tangens = tan(angle);
    double err = 10.0;
    double countedY = a.dy + (tangens * (x - a.dx).abs());
    top = countedY - err;
    bottom = countedY + err;
  }
}

// when Rect A and Rect B are in one line (but angle is incorrect)
bool rectsHeightsIntersect(final Rect a, final Rect b) {
  isInsideRectA(double y) => a.top < b.bottom && b.bottom < a.bottom;
  return isInsideRectA(b.bottom) || isInsideRectA(b.top);
}