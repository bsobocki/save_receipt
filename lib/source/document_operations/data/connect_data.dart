import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:save_receipt/source/document_operations/math/coordinates.dart';

class ConnectedTextLines {
  final TextLine start;
  final TextLine? connectedLine;

  ConnectedTextLines({required this.start, required this.connectedLine});

  @override
  String toString() =>
      '{start: ${start.text} => [${connectedLine?.text ?? ''}]}\n';
}

// O (n^2)
List<ConnectedTextLines> getConnectedTextLines(List<TextLine> lines) {
  List<TextLine?> textLines = [...lines];
  List<ConnectedTextLines> connectedLines = [];

  for (int i = 0; i < textLines.length; i++) {
    if (textLines[i] != null) {
      TextLine startLine = textLines[i]!;
      TextLine? connectedLine;
      for (int j = i + 1; j < textLines.length; j++) {
        if (textLines[j] != null) {
          TextLine currentLine = textLines[j]!;
          if (areInTheSameLine(startLine, currentLine)) {
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

// O(n log n)  => sort by (bottomLeft).y
// binary search for the textLine

bool areInTheSameLine(TextLine a, TextLine b) {
  bool result = false;
  Offset aBottomCoords = a.boundingBox.center;
  Offset bBottomCoords = b.boundingBox.center;
  VerticalMargin marginBottomLeft =
      VerticalMargin.calc(a.angle ?? 0.0, aBottomCoords, bBottomCoords.dx);
  result = result || marginBottomLeft.inMargin(bBottomCoords.dy);

  return result;
}
