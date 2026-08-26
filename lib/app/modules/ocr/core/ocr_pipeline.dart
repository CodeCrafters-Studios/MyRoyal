import 'package:image/image.dart';

import '../models/ktp_field_regions.dart';
import '../models/ktp_result.dart';
import '../services/ktp_validator.dart';
import '../services/ocr_quality_analyzer.dart';
import '../utils/ktp_dictionaries.dart';
import '../debug/ocr_debug_logger.dart';
import 'field_ocr_engine.dart';
import 'field_region_extractor.dart';
import 'image_preprocessor.dart';
import 'ktp_image_normalizer.dart';
import 'ktp_result_builder.dart';
import 'label_detector.dart';
import 'layout_analyzer.dart';
import 'ocr_recognizer.dart';
import 'voting_engine.dart';

class OcrPipeline {
  final OcrRecognizer _recognizer = OcrRecognizer();

  Future<KtpResult> process(String originalImagePath) async {
    // 1. Image Quality Validation
    final qualityReport = await OcrQualityAnalyzer.analyze(originalImagePath);
    if (!qualityReport.isAcceptable) {
      OcrDebugLogger.logPipelineCompletion(
          'Warning: Image quality report: $qualityReport');
    }

    // 2. Image Normalization & Canonical Coordinate Transformation
    final normResult = await KtpImageNormalizer.normalize(originalImagePath);
    OcrDebugLogger.logImageNormalization(
      originalPath: originalImagePath,
      normalizedPath: normResult.normalizedPath,
      width: normResult.width,
      height: normResult.height,
    );

    // 3. Primary Field-Level ROI Extraction Pipeline
    final fieldEngine = FieldOcrEngine(_recognizer);
    final KtpResult result = KtpResult();

    // Field 1: NIK
    final nikCandidates = await fieldEngine.readNik(
      normalizedImage: normResult.image,
      region: KtpFieldRegions.nik,
    );
    result.nik = VotingEngine.selectBestField(
      candidatePool: nikCandidates,
      validator: KtpValidator.validateNik,
      fieldName: 'NIK',
    );
    OcrDebugLogger.logFieldOcr(
      fieldName: 'NIK',
      roi: KtpFieldRegions.nik.normalizedRect,
      rawTexts: nikCandidates.map((c) => c.value).toList(),
      candidates: nikCandidates,
      finalSelectedValue: result.nik.value,
      finalConfidence: result.nik.confidence,
    );

    // Field 2: Nama Lengkap
    final nameCandidates = await fieldEngine.readName(
      normalizedImage: normResult.image,
      region: KtpFieldRegions.name,
    );
    result.name = VotingEngine.selectBestField(
      candidatePool: nameCandidates,
      validator: KtpValidator.validateName,
      fieldName: 'Nama Lengkap',
    );

    // Field 3 & 4: Tempat & Tanggal Lahir
    final birthMap = await fieldEngine.readBirth(
      normalizedImage: normResult.image,
      region: KtpFieldRegions.birthPlaceDate,
    );
    result.birthPlace = VotingEngine.selectBestField(
      candidatePool: birthMap['birthPlace'] ?? [],
      validator: (v) => v.isNotEmpty,
      fieldName: 'Tempat Lahir',
    );
    result.birthDate = VotingEngine.selectBestField(
      candidatePool: birthMap['birthDate'] ?? [],
      validator: KtpValidator.validateDate,
      fieldName: 'Tanggal Lahir',
    );

    // Field 5: Jenis Kelamin
    final genderCandidates = await fieldEngine.readDictionaryField(
      normalizedImage: normResult.image,
      region: KtpFieldRegions.gender,
      dictionary: KtpDictionaries.genders,
    );
    result.gender = VotingEngine.selectBestField(
      candidatePool: genderCandidates,
      validator: KtpValidator.validateGender,
      fieldName: 'Jenis Kelamin',
    );

    // Field 6: Alamat
    final addressCandidates = await fieldEngine.readTextField(
      normalizedImage: normResult.image,
      region: KtpFieldRegions.address,
    );
    result.address = VotingEngine.selectBestField(
      candidatePool: addressCandidates,
      validator: (v) => v.isNotEmpty,
      fieldName: 'Alamat',
    );

    // Field 7 & 8: RT & RW
    final rtRwMap = await fieldEngine.readRtRw(
      normalizedImage: normResult.image,
      region: KtpFieldRegions.rtRw,
    );
    result.rt = VotingEngine.selectBestField(
      candidatePool: rtRwMap['RT'] ?? [],
      validator: (v) => v.length == 3,
      fieldName: 'RT',
    );
    result.rw = VotingEngine.selectBestField(
      candidatePool: rtRwMap['RW'] ?? [],
      validator: (v) => v.length == 3,
      fieldName: 'RW',
    );

    // Field 9: Kelurahan/Desa
    final villageCandidates = await fieldEngine.readTextField(
      normalizedImage: normResult.image,
      region: KtpFieldRegions.village,
    );
    result.village = VotingEngine.selectBestField(
      candidatePool: villageCandidates,
      validator: (v) => v.isNotEmpty,
      fieldName: 'Kelurahan/Desa',
    );

    // Field 10: Kecamatan
    final districtCandidates = await fieldEngine.readTextField(
      normalizedImage: normResult.image,
      region: KtpFieldRegions.district,
    );
    result.district = VotingEngine.selectBestField(
      candidatePool: districtCandidates,
      validator: (v) => v.isNotEmpty,
      fieldName: 'Kecamatan',
    );

    // Field 11: Agama
    final religionCandidates = await fieldEngine.readDictionaryField(
      normalizedImage: normResult.image,
      region: KtpFieldRegions.religion,
      dictionary: KtpDictionaries.religions,
    );
    result.religion = VotingEngine.selectBestField(
      candidatePool: religionCandidates,
      validator: KtpValidator.validateReligion,
      fieldName: 'Agama',
    );

    // Field 12: Status Perkawinan
    final maritalCandidates = await fieldEngine.readDictionaryField(
      normalizedImage: normResult.image,
      region: KtpFieldRegions.maritalStatus,
      dictionary: KtpDictionaries.maritalStatuses,
    );
    result.maritalStatus = VotingEngine.selectBestField(
      candidatePool: maritalCandidates,
      validator: (v) => KtpDictionaries.maritalStatuses.contains(v),
      fieldName: 'Status Perkawinan',
    );

    // Field 13: Pekerjaan
    final workCandidates = await fieldEngine.readDictionaryField(
      normalizedImage: normResult.image,
      region: KtpFieldRegions.work,
      dictionary: KtpDictionaries.jobs,
      threshold: 55.0,
    );
    result.work = VotingEngine.selectBestField(
      candidatePool: workCandidates,
      validator: (v) => v.isNotEmpty,
      fieldName: 'Pekerjaan',
    );

    // Field 14: Kewarganegaraan
    final natCandidates = await fieldEngine.readDictionaryField(
      normalizedImage: normResult.image,
      region: KtpFieldRegions.nationality,
      dictionary: KtpDictionaries.nationalities,
    );
    result.nationality = VotingEngine.selectBestField(
      candidatePool: natCandidates,
      validator: KtpValidator.validateNationality,
      fieldName: 'Kewarganegaraan',
    );

    // Field 15: Provinsi Header (if missing, use dictionary reader on top ROI)
    final provCandidates = await fieldEngine.readDictionaryField(
      normalizedImage: normResult.image,
      region: KtpFieldRegions.provinceHeader,
      dictionary: KtpDictionaries.provinces,
      threshold: 60.0,
    );
    result.province = VotingEngine.selectBestField(
      candidatePool: provCandidates,
      validator: KtpValidator.validateProvince,
      fieldName: 'Provinsi',
    );

    // 4. Targeted Retry Strategy for missing / low-confidence key fields
    await _executeTargetedRetry(normResult.image, result, fieldEngine);

    // 5. Label Detector Fallback if crucial fields remain completely empty
    if (result.nik.isEmpty || result.name.isEmpty) {
      await _executeLabelDetectorFallback(normResult.normalizedPath, result);
    }

    // Cleanup normalized image temp file
    await ImagePreprocessor.cleanupFiles([normResult.normalizedPath]);

    OcrDebugLogger.logPipelineCompletion(result.toString());
    return result;
  }

  /// Targeted Retry Strategy: Expands ROI slightly and reruns OCR ONLY for missing key fields
  Future<void> _executeTargetedRetry(
    Image normalizedImage,
    KtpResult currentResult,
    FieldOcrEngine engine,
  ) async {
    // Retry NIK if missing or low confidence
    if (currentResult.nik.isEmpty || currentResult.nik.confidence < 75.0) {
      final expandedNikRegion = KtpFieldRegion(
        field: 'NIK_Expanded',
        normalizedRect: KtpFieldRegions.nik.normalizedRect.expand(0.03),
      );
      final retryNikCandidates = await engine.readNik(
        normalizedImage: normalizedImage,
        region: expandedNikRegion,
      );
      final retryNik = VotingEngine.selectBestField(
        candidatePool: retryNikCandidates,
        validator: KtpValidator.validateNik,
        fieldName: 'NIK_Retry',
      );
      if (retryNik.confidence > currentResult.nik.confidence) {
        currentResult.nik = retryNik;
      }
    }

    // Retry Name if missing or low confidence
    if (currentResult.name.isEmpty || currentResult.name.confidence < 75.0) {
      final expandedNameRegion = KtpFieldRegion(
        field: 'Nama_Expanded',
        normalizedRect: KtpFieldRegions.name.normalizedRect.expand(0.03),
      );
      final retryNameCandidates = await engine.readName(
        normalizedImage: normalizedImage,
        region: expandedNameRegion,
      );
      final retryName = VotingEngine.selectBestField(
        candidatePool: retryNameCandidates,
        validator: KtpValidator.validateName,
        fieldName: 'Nama_Retry',
      );
      if (retryName.confidence > currentResult.name.confidence) {
        currentResult.name = retryName;
      }
    }
  }

  /// Fallback mechanism using full-image label search if ROI extraction failed completely
  Future<void> _executeLabelDetectorFallback(
      String imagePath, KtpResult result) async {
    try {
      final doc = await _recognizer.processImage(imagePath);
      final analyzer = LayoutAnalyzer(doc);
      final labelDetector = LabelDetector(analyzer);
      final extractor = FieldRegionExtractor(analyzer, labelDetector);
      final rawFields = extractor.extractFieldValues();
      final fallbackResult =
          KtpResultBuilder(rawFields, 'fallback_label_detector').build();

      if (result.nik.isEmpty && fallbackResult.nik.value.isNotEmpty) {
        result.nik = fallbackResult.nik;
      }
      if (result.name.isEmpty && fallbackResult.name.value.isNotEmpty) {
        result.name = fallbackResult.name;
      }
    } catch (_) {}
  }

  void dispose() {
    _recognizer.dispose();
  }
}
