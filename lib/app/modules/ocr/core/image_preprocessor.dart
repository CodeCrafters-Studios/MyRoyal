import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

enum CropPreprocessingVariant {
  original,
  grayscale,
  contrast,
  adaptiveThreshold,
  sharpen,
}

class CropVariationResult {
  final CropPreprocessingVariant variant;
  final String imagePath;

  const CropVariationResult({
    required this.variant,
    required this.imagePath,
  });
}

class ImagePreprocessor {
  /// Generates field-crop level preprocessing variations tailored to field OCR needs.
  /// Operates directly on field crop image files to maximize performance and detail.
  static Future<List<CropVariationResult>> generateCropVariations({
    required String cropPath,
    required List<CropPreprocessingVariant> requestedVariants,
  }) async {
    List<CropVariationResult> results = [];
    final file = File(cropPath);
    if (!await file.exists()) return results;

    final bytes = await file.readAsBytes();
    final img.Image? baseCrop = img.decodeImage(bytes);
    if (baseCrop == null) return results;

    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().microsecondsSinceEpoch;

    for (final variant in requestedVariants) {
      try {
        if (variant == CropPreprocessingVariant.original) {
          results
              .add(CropVariationResult(variant: variant, imagePath: cropPath));
          continue;
        }

        img.Image processed;
        switch (variant) {
          case CropPreprocessingVariant.grayscale:
            processed = img.grayscale(baseCrop.clone());
            break;
          case CropPreprocessingVariant.contrast:
            processed =
                img.adjustColor(img.grayscale(baseCrop.clone()), contrast: 1.4);
            break;
          case CropPreprocessingVariant.adaptiveThreshold:
            // High contrast gentle thresholding preserving edge boundaries
            final gray = img.grayscale(baseCrop.clone());
            processed = img.adjustColor(gray, contrast: 1.8, brightness: 1.05);
            break;
          case CropPreprocessingVariant.sharpen:
            // Real unsharp mask / laplacian sharpening convolution
            final gray = img.grayscale(baseCrop.clone());
            processed = img.convolution(
              gray,
              filter: [
                0,
                -1,
                0,
                -1,
                5,
                -1,
                0,
                -1,
                0,
              ],
              div: 1,
              offset: 0,
            );
            break;
          case CropPreprocessingVariant.original:
            processed = baseCrop;
            break;
        }

        final String varPath =
            '${tempDir.path}/crop_${variant.name}_$timestamp.jpg';
        await File(varPath).writeAsBytes(img.encodeJpg(processed, quality: 95));
        results.add(CropVariationResult(variant: variant, imagePath: varPath));
      } catch (e) {
        // Fallback to original crop if variation fails
        results.add(CropVariationResult(
            variant: CropPreprocessingVariant.original, imagePath: cropPath));
      }
    }

    return results;
  }

  /// Cleans up temporary crop and preprocessing variant files to prevent memory/storage leaks.
  static Future<void> cleanupFiles(List<String> paths) async {
    for (final path in paths) {
      try {
        final f = File(path);
        if (await f.exists()) {
          await f.delete();
        }
      } catch (_) {}
    }
  }
}
