import 'dart:core';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:save_receipt/source/document_operations/math/coordinates.dart';

class ConnectedTextLines {
  final TextLine start;
  List<TextLine> connectedLines = [];

  ConnectedTextLines({required this.start});

  String getTextLinesStr() {
    String output = '';
    for (TextLine line in connectedLines) {
      output += line.text;
      output += ',';
    }
    return output;
  }

  @override
  String toString() =>
      '{start: ${start.text}|${start.boundingBox.bottomLeft} => [${getTextLinesStr()}]}\n';
}

// O (n^2)
List<ConnectedTextLines> getConnectedTextLines(List<TextLine> lines) {
  List<TextLine?> textLines = [...lines];
  List<ConnectedTextLines> connectedLines = [];

  for (int i = 0; i < textLines.length; i++) {
    if (textLines[i] != null) {
      TextLine startLine = textLines[i]!;
      var connectedToStart = ConnectedTextLines(start: startLine);
      for (int j = i + 1; j < textLines.length; j++) {
        if (textLines[j] != null) {
          TextLine currentLine = textLines[j]!;
          if (areInTheSameLine(startLine, currentLine)) {
            connectedToStart.connectedLines.add(currentLine);
            textLines[j] = null;
          }
        }
      }
      connectedLines.add(connectedToStart);
    }
  }

  return connectedLines;
}

// O(n log n)  => sort by (bottomLeft).y
// binary search for the textLine

bool areInTheSameLine(TextLine a, TextLine b) {
  Offset aCoords = a.boundingBox.center;
  Offset bCoords = b.boundingBox.center;
  VerticalMargin margin =
      VerticalMargin.calc(a.angle ?? 0.0, aCoords, bCoords.dx);
  return margin.inMargin(bCoords.dy);
}
