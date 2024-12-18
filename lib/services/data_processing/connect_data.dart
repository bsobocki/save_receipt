import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:save_receipt/domain/entities/connected_data.dart';
import 'package:save_receipt/core/utils/coordinates.dart';

enum CheckLines {
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
    List<TextLine> lines, CheckLines check) {
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
          if (areInTheSameLine(startLine, currentLine, CheckLines.bottom) ||
              areInTheSameLine(startLine, currentLine, CheckLines.center) ||
              areInTheSameLine(startLine, currentLine, CheckLines.top)) {
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

bool areInTheSameLine(TextLine a, TextLine b, CheckLines check) {
  bool result = false;
  Offset aBottomCoords = getCoords(a.boundingBox, check);
  Offset bBottomCoords = getCoords(b.boundingBox, check);
  VerticalMargin marginBottomLeft =
      VerticalMargin.calc(a.angle ?? 0.0, aBottomCoords, bBottomCoords.dx);
  result = result || marginBottomLeft.inMargin(bBottomCoords.dy);
  result = result &&
      getCoords(b.boundingBox, CheckLines.centerLeft).dx >=
          getCoords(a.boundingBox, CheckLines.centerRight).dx;

  return result;
}

Offset getCoords(Rect r, CheckLines check) {
  switch (check) {
    case CheckLines.top:
      return r.topCenter;
    case CheckLines.bottom:
      return r.bottomCenter;
    case CheckLines.center:
      return r.center;
    case CheckLines.topLeft:
      return r.topLeft;
    case CheckLines.topRight:
      return r.topRight;
    case CheckLines.bottomLeft:
      return r.bottomLeft;
    case CheckLines.bottomRight:
      return r.bottomRight;
    case CheckLines.centerLeft:
      return r.centerLeft;
    case CheckLines.centerRight:
      return r.centerRight;
  }
}
