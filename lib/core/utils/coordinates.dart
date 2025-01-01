import 'dart:math';
import 'dart:ui';

/*
* Text Lines that are connected using this class for calculation uses Rect object
* to describe its position
*
* Vertical Margin for rect B (based on rect A) calculates Y value
* that should be a coordinate of B based on its X coordinate using triangle, angle and tangens.
* It creates a margin, not just one Y value, because text lines can be a little bit moved (not in perfect position)
*
* if we have a big line that contains two Text Lines and it rotates with some angle,
* then to take the first one A (its position and rotate angle) and calculate Y coordinate of second one B,
* we can use a triangle.
*
* If we have the center point of A as a vertex of triangle
* and the hypotenuse of this triangle lies on the line that contains centers of A and B
* and we have X coordinate of B, then we can calculate where should be its Y coordinate
* to know if this Text Line is the one that we are looking for.
*
*
*                                         + B
*                                         |
*                                         |
*   A +-----------------------------------+ C
*
* we know the length of AC (B.x - A.x) and angle CAB
* so using tan(angle) = BC/AC we can calculate BC
* BC = tan(angle) * AC = tan(angle) * |B.x - A.x|
* and with that we can calculate B.y (A.y + |BC|)
*/

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
