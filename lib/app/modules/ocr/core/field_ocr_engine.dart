import 'package:image/image.dart' as img;

import '../models/ktp_field_regions.dart';
import '../models/ocr_candidate.dart';
import '../parsers/date_parser.dart';
import '../parsers/dictionary_parser.dart';
import '../parsers/name_parser.dart';
import '../parsers/nik_candidate_generator.dart';
import '../parsers/rt_rw_parser.dart';
import 'image_preprocessor.dart';
import 'ktp_image_normalizer.dart';
import 'ocr_recognizer.dart';

class FieldOcrEngine {
  final OcrRecognizer recognizer;

  FieldOcrEngine(this.recognizer);

  /// Reads NIK using high contrast & adaptive threshold crop variations
  Future<List<OcrCandidate>> readNik({
    required img.Image normalizedImage,
    required KtpFieldRegion region,
  }) async {
    final cropPath = await KtpImageNormalizer.cropRoi(
      baseImage: normalizedImage,
      roi: region.normalizedRect,
      fieldName: region.field,
    );

    final variations = await ImagePreprocessor.generateCropVariations(
      cropPath: cropPath,
      requestedVariants: [
        CropPreprocessingVariant.original,
        CropPreprocessingVariant.contrast,
        CropPreprocessingVariant.adaptiveThreshold,
      ],
    );

    List<OcrCandidate> candidates = [];
    List<String> tempPathsToCleanup = [cropPath];

    for (final varItem in variations) {
      if (varItem.imagePath != cropPath)
        tempPathsToCleanup.add(varItem.imagePath);

      final doc = await recognizer.processImage(varItem.imagePath);
      List<String> rawTexts = [];
      double? lineConf;

      for (final block in doc.blocks) {
        for (final line in block.lines) {
          rawTexts.add(line.text);
          lineConf ??= line.confidence;
          for (final element in line.elements) {
            rawTexts.add(element.text);
          }
        }
      }

      final generated = NikCandidateGenerator.generateCandidates(
        rawTexts: rawTexts,
        sourceName: 'roi_${varItem.variant.name}',
        mlKitConfidence: lineConf,
      );
      candidates.addAll(generated);
    }

    await ImagePreprocessor.cleanupFiles(tempPathsToCleanup);
    return candidates;
  }

  /// Reads Name preserving multi-word names without aggressive dictionary corruption
  Future<List<OcrCandidate>> readName({
    required img.Image normalizedImage,
    required KtpFieldRegion region,
  }) async {
    final cropPath = await KtpImageNormalizer.cropRoi(
      baseImage: normalizedImage,
      roi: region.normalizedRect,
      fieldName: region.field,
    );

    final variations = await ImagePreprocessor.generateCropVariations(
      cropPath: cropPath,
      requestedVariants: [
        CropPreprocessingVariant.original,
        CropPreprocessingVariant.grayscale,
      ],
    );

    List<OcrCandidate> candidates = [];
    List<String> tempPathsToCleanup = [cropPath];

    for (final varItem in variations) {
      if (varItem.imagePath != cropPath)
        tempPathsToCleanup.add(varItem.imagePath);

      final doc = await recognizer.processImage(varItem.imagePath);
      for (final block in doc.blocks) {
        for (final line in block.lines) {
          final candidate = NameParser.parse(
            line.text,
            'roi_${varItem.variant.name}',
            mlKitConfidence: line.confidence,
          );
          if (candidate.value.isNotEmpty) candidates.add(candidate);
        }
      }
    }

    await ImagePreprocessor.cleanupFiles(tempPathsToCleanup);
    return candidates;
  }

  /// Reads Birth Place and Date of Birth
  Future<Map<String, List<OcrCandidate>>> readBirth({
    required img.Image normalizedImage,
    required KtpFieldRegion region,
  }) async {
    final cropPath = await KtpImageNormalizer.cropRoi(
      baseImage: normalizedImage,
      roi: region.normalizedRect,
      fieldName: region.field,
    );

    final variations = await ImagePreprocessor.generateCropVariations(
      cropPath: cropPath,
      requestedVariants: [
        CropPreprocessingVariant.original,
        CropPreprocessingVariant.contrast,
      ],
    );

    List<OcrCandidate> placeCandidates = [];
    List<OcrCandidate> dateCandidates = [];
    List<String> tempPathsToCleanup = [cropPath];

    for (final varItem in variations) {
      if (varItem.imagePath != cropPath)
        tempPathsToCleanup.add(varItem.imagePath);

      final doc = await recognizer.processImage(varItem.imagePath);
      for (final block in doc.blocks) {
        for (final line in block.lines) {
          final res = DateParser.parseBirthPlaceAndDate(
            line.text,
            'roi_${varItem.variant.name}',
            mlKitConfidence: line.confidence,
          );
          if (res['birthPlace']!.value.isNotEmpty)
            placeCandidates.add(res['birthPlace']!);
          if (res['birthDate']!.value.isNotEmpty)
            dateCandidates.add(res['birthDate']!);
        }
      }
    }

    await ImagePreprocessor.cleanupFiles(tempPathsToCleanup);
    return {
      'birthPlace': placeCandidates,
      'birthDate': dateCandidates,
    };
  }

  /// Reads RT/RW field crop
  Future<Map<String, List<OcrCandidate>>> readRtRw({
    required img.Image normalizedImage,
    required KtpFieldRegion region,
  }) async {
    final cropPath = await KtpImageNormalizer.cropRoi(
      baseImage: normalizedImage,
      roi: region.normalizedRect,
      fieldName: region.field,
    );

    final variations = await ImagePreprocessor.generateCropVariations(
      cropPath: cropPath,
      requestedVariants: [
        CropPreprocessingVariant.original,
        CropPreprocessingVariant.contrast,
      ],
    );

    List<OcrCandidate> rtCandidates = [];
    List<OcrCandidate> rwCandidates = [];
    List<String> tempPathsToCleanup = [cropPath];

    for (final varItem in variations) {
      if (varItem.imagePath != cropPath)
        tempPathsToCleanup.add(varItem.imagePath);

      final doc = await recognizer.processImage(varItem.imagePath);
      for (final block in doc.blocks) {
        for (final line in block.lines) {
          final res = RtRwParser.parseRtRw(
            line.text,
            'roi_${varItem.variant.name}',
            mlKitConfidence: line.confidence,
          );
          if (res['RT']!.value.isNotEmpty) rtCandidates.add(res['RT']!);
          if (res['RW']!.value.isNotEmpty) rwCandidates.add(res['RW']!);
        }
      }
    }

    await ImagePreprocessor.cleanupFiles(tempPathsToCleanup);
    return {
      'RT': rtCandidates,
      'RW': rwCandidates,
    };
  }

  /// Generic text/address field reader
  Future<List<OcrCandidate>> readTextField({
    required img.Image normalizedImage,
    required KtpFieldRegion region,
  }) async {
    final cropPath = await KtpImageNormalizer.cropRoi(
      baseImage: normalizedImage,
      roi: region.normalizedRect,
      fieldName: region.field,
    );

    final doc = await recognizer.processImage(cropPath);
    List<OcrCandidate> candidates = [];

    for (final block in doc.blocks) {
      for (final line in block.lines) {
        final text = line.text.replaceAll(':', '').trim();
        if (text.isNotEmpty) {
          final double? lineConf = line.confidence;
          final double score = lineConf != null && lineConf > 0
              ? lineConf.clamp(0.0, 90.0)
              : 82.0;
          candidates.add(OcrCandidate(
            value: text,
            score: score,
            source: 'roi_original',
            mlKitConfidence: lineConf,
          ));
        }
      }
    }

    await ImagePreprocessor.cleanupFiles([cropPath]);
    return candidates;
  }

  /// Reads Dictionary-matched fields (Gender, Religion, Marital Status, Province, Work, Nationality)
  Future<List<OcrCandidate>> readDictionaryField({
    required img.Image normalizedImage,
    required KtpFieldRegion region,
    required List<String> dictionary,
    double threshold = 65.0,
  }) async {
    final cropPath = await KtpImageNormalizer.cropRoi(
      baseImage: normalizedImage,
      roi: region.normalizedRect,
      fieldName: region.field,
    );

    final doc = await recognizer.processImage(cropPath);
    final parser = DictionaryParser(
        dictionary: dictionary, minConfidenceThreshold: threshold);
    List<OcrCandidate> candidates = [];

    for (final block in doc.blocks) {
      for (final line in block.lines) {
        final candidate = parser.parseCandidate(line.text, 'roi_dict',
            mlKitConfidence: line.confidence);
        if (candidate.value.isNotEmpty) candidates.add(candidate);
      }
    }

    await ImagePreprocessor.cleanupFiles([cropPath]);
    return candidates;
  }
}
