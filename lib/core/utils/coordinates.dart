import 'dart:math';
import 'dart:ui';

class VerticalMargin {
  late final double top;
  late final double bottom;

  VerticalMargin({required this.top, required this.bottom});

  inMargin(final double y) => bottom <= y && y <= top;

  @override
  String toString() => '{top: $top, bottom: $bottom}';

  VerticalMargin.calc(final double rotate, final Offset a, final double x,
      {final err = 10.0}) {
    double angle = rotate * (pi / 180);
    double tangens = tan(angle);
    double countedY = a.dy + (tangens * (x - a.dx).abs());
    bottom = countedY - err;
    top = countedY + err;
  }
}

// when Rect A and Rect B are in one line (but angle is incorrect)
bool rectsIntersectVertically(final Rect a, final Rect b) {
  isInsideRectA(double y) => a.top <= y && y <= a.bottom;
  return isInsideRectA(b.bottom) || isInsideRectA(b.top) || isInsideRectA(b.center.dy);
}
