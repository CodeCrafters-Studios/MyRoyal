import 'dart:ui';
import 'ocr_document.dart';

class LayoutAnalyzer {
  final OcrDocument document;

  LayoutAnalyzer(this.document);

  /// Builds a 2D sorted list of lines (Top to Bottom, Left to Right)
  List<OcrLine> getSortedLines() {
    List<OcrLine> allLines = [];
    for (var block in document.blocks) {
      allLines.addAll(block.lines);
    }

    allLines.sort((a, b) {
      // If Y difference is small (e.g., < 15 pixels), they are on the same line.
      // Then sort by X.
      double yDiff = a.boundingBox.top - b.boundingBox.top;
      if (yDiff.abs() < 15) {
        return a.boundingBox.left.compareTo(b.boundingBox.left);
      }
      return yDiff.compareTo(0);
    });

    return allLines;
  }

  /// Finds the physical block of text that is immediately to the right of a given Rect
  String? findTextToRight(Rect anchor, {double maxDistance = 500.0}) {
    OcrLine? closestLine;
    double minDistance = double.infinity;
    // Dynamic vertical tolerance based on anchor height
    double verticalTolerance = anchor.height * 1.5;
    if (verticalTolerance < 25.0) verticalTolerance = 25.0;

    for (var block in document.blocks) {
      for (var line in block.lines) {
        // Must be to the right of the anchor
        if (line.boundingBox.left > anchor.right - 10) {
          // Check alignment using center Y to be more robust to rotation
          double anchorCenterY = anchor.top + (anchor.height / 2);
          double lineCenterY =
              line.boundingBox.top + (line.boundingBox.height / 2);
          if ((lineCenterY - anchorCenterY).abs() < verticalTolerance) {
            double dist = line.boundingBox.left - anchor.right;
            if (dist < minDistance && dist < maxDistance) {
              minDistance = dist;
              closestLine = line;
            }
          }
        }
      }
    }

    // Clean colon if it accidentally became part of the value
    String? result = closestLine?.text;
    if (result != null && result.startsWith(':')) {
      result = result.replaceFirst(':', '').trim();
    }
    return result;
  }

  /// Finds the physical block of text immediately below a given Rect
  String? findTextBelow(Rect anchor,
      {double maxVerticalDistance = 120.0,
      double horizontalTolerance = 300.0}) {
    OcrLine? closestLine;
    double minDistance = double.infinity;

    for (var block in document.blocks) {
      for (var line in block.lines) {
        // Must be below the anchor
        if (line.boundingBox.top > anchor.bottom - 10) {
          // or just standard left alignment with big tolerance
          if ((line.boundingBox.left - anchor.left).abs() <
              horizontalTolerance) {
            double dist = line.boundingBox.top - anchor.bottom;
            if (dist < minDistance && dist < maxVerticalDistance) {
              minDistance = dist;
              closestLine = line;
            }
          }
        }
      }
    }

    return closestLine?.text;
  }
}
