import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'ocr_document.dart';

class OcrRecognizer {
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  Future<OcrDocument> processImage(String imagePath) async {
    final InputImage inputImage = InputImage.fromFilePath(imagePath);
    final RecognizedText recognizedText =
        await _textRecognizer.processImage(inputImage);
    return OcrDocument.fromRecognizedText(recognizedText);
  }

  void dispose() {
    _textRecognizer.close();
  }
}
