import 'dart:ui';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// A wrapper around ML Kit's RecognizedText that keeps spatial bounding boxes
/// intact through the entire pipeline.
class OcrDocument {
  final List<OcrBlock> blocks;

  OcrDocument({required this.blocks});

  factory OcrDocument.fromRecognizedText(RecognizedText text) {
    List<OcrBlock> parsedBlocks =
        text.blocks.map((b) => OcrBlock.fromMlKit(b)).toList();

    return OcrDocument(blocks: parsedBlocks);
  }
}

class OcrBlock {
  final String text;
  final Rect boundingBox;
  final List<OcrLine> lines;

  OcrBlock({
    required this.text,
    required this.boundingBox,
    required this.lines,
  });

  factory OcrBlock.fromMlKit(TextBlock block) {
    return OcrBlock(
      text: block.text,
      boundingBox: block.boundingBox,
      lines: block.lines.map((l) => OcrLine.fromMlKit(l)).toList(),
    );
  }
}

class OcrLine {
  final String text;
  final Rect boundingBox;
  final double? confidence;
  final List<OcrElement> elements;

  OcrLine({
    required this.text,
    required this.boundingBox,
    this.confidence,
    required this.elements,
  });

  factory OcrLine.fromMlKit(TextLine line) {
    double? conf = line.confidence;
    if (conf != null && conf <= 1.0) {
      conf = conf * 100.0;
    }
    if (conf == null && line.elements.isNotEmpty) {
      final elConfs =
          line.elements.map((e) => e.confidence).whereType<double>().toList();
      if (elConfs.isNotEmpty) {
        final avg = elConfs.reduce((a, b) => a + b) / elConfs.length;
        conf = avg <= 1.0 ? avg * 100.0 : avg;
      }
    }

    return OcrLine(
      text: line.text,
      boundingBox: line.boundingBox,
      confidence: conf,
      elements: line.elements.map((e) => OcrElement.fromMlKit(e)).toList(),
    );
  }
}

class OcrElement {
  final String text;
  final Rect boundingBox;
  final double? confidence;

  OcrElement({
    required this.text,
    required this.boundingBox,
    this.confidence,
  });

  factory OcrElement.fromMlKit(TextElement element) {
    double? conf = element.confidence;
    if (conf != null && conf <= 1.0) {
      conf = conf * 100.0;
    }
    return OcrElement(
      text: element.text,
      boundingBox: element.boundingBox,
      confidence: conf,
    );
  }
}
