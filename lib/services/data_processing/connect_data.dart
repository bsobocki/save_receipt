import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:save_receipt/domain/entities/connected_data.dart';
import 'package:save_receipt/core/utils/coordinates.dart';

enum RectArea {
  top,
  topLeft,
  topRight,
  bottom,
  bottomLeft,
  bottomRight,
  center,
  centerLeft,
  centerRight
}

// O (n^2)
List<ConnectedTextLines> getConnectedTextLines(
    List<TextLine> lines, RectArea check) {
  List<TextLine?> textLines = [...lines];
  List<ConnectedTextLines> connectedLines = [];

  lines.sort(
      (a, b) => a.boundingBox.center.dy.compareTo(b.boundingBox.center.dy));

  for (int i = 0; i < textLines.length; i++) {
    if (textLines[i] != null) {
      TextLine startLine = textLines[i]!;
      TextLine? connectedLine;

      for (int j = i + 1; j < textLines.length; j++) {
        if (textLines[j] != null) {
          TextLine currentLine = textLines[j]!;
          if (areInTheSameLine(startLine, currentLine, RectArea.bottom) ||
              areInTheSameLine(startLine, currentLine, RectArea.center) ||
              areInTheSameLine(startLine, currentLine, RectArea.top)) {
            connectedLine = currentLine;
            textLines[j] = null;
            break;
          }
        }
      }
      connectedLines.add(
        ConnectedTextLines(
          start: startLine,
          connectedLine: connectedLine,
        ),
      );
    }
  }

  return connectedLines;
}

// Todo:
/* 
** O(n log n)  => sort by (bottomLeft).y
** binary search for the textLine
*/
// List<ConnectedTextLines> getConnectedTextLines(List<TextLine> lines) {}

bool areInTheSameLine(TextLine a, TextLine b, RectArea area) {
  double angle = a.angle ?? 0.0;
  Offset cordsA = getCoords(a.boundingBox, area);
  Offset cordsB = getCoords(b.boundingBox, area);

  VerticalMargin marginBottomLeft =
      VerticalMargin.calc(angle, cordsA, cordsB.dx);

  bool bYIsInVerticalMarginCalculatedWithRectA =
      marginBottomLeft.inMargin(cordsB.dy);

  bool bDoesNotIntersectOnTheXAxis =
      getCoords(b.boundingBox, RectArea.centerLeft).dx >=
          getCoords(a.boundingBox, RectArea.centerRight).dx;

  return bYIsInVerticalMarginCalculatedWithRectA && bDoesNotIntersectOnTheXAxis;
}

Offset getCoords(Rect r, RectArea area) {
  switch (area) {
    case RectArea.top:
      return r.topCenter;
    case RectArea.bottom:
      return r.bottomCenter;
    case RectArea.center:
      return r.center;
    case RectArea.topLeft:
      return r.topLeft;
    case RectArea.topRight:
      return r.topRight;
    case RectArea.bottomLeft:
      return r.bottomLeft;
    case RectArea.bottomRight:
      return r.bottomRight;
    case RectArea.centerLeft:
      return r.centerLeft;
    case RectArea.centerRight:
      return r.centerRight;
  }
}
