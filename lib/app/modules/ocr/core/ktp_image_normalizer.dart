import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../models/ktp_field_regions.dart';

class NormalizedImageResult {
  final String normalizedPath;
  final img.Image image;
  final int width;
  final int height;
  final bool isOrientationFixed;

  const NormalizedImageResult({
    required this.normalizedPath,
    required this.image,
    required this.width,
    required this.height,
    required this.isOrientationFixed,
  });
}

class KtpImageNormalizer {
  /// Normalizes input image: fixes EXIF orientation, ensures min resolution,
  /// produces clean normalized image file in canonical coordinate space.
  static Future<NormalizedImageResult> normalize(
      String originalImagePath) async {
    final file = File(originalImagePath);
    final bytes = await file.readAsBytes();
    img.Image? decoded = img.decodeImage(bytes);

    if (decoded == null) {
      throw Exception("Could not decode image at path: $originalImagePath");
    }

    // Fix EXIF orientation
    img.Image oriented = img.bakeOrientation(decoded);
    bool orientationFixed =
        oriented.width != decoded.width || oriented.height != decoded.height;

    // Ensure width > height for KTP landscape orientation if rotated
    if (oriented.height > oriented.width * 1.1) {
      oriented = img.copyRotate(oriented, angle: -90);
      orientationFixed = true;
    }

    // Preserve high resolution, but cap maximum dimension if unreasonably large (e.g. > 3000px)
    if (oriented.width > 2400) {
      oriented = img.copyResize(oriented, width: 2400);
    }

    final tempDir = await getTemporaryDirectory();
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String normalizedPath = '${tempDir.path}/ktp_norm_$timestamp.jpg';

    final normalizedBytes = img.encodeJpg(oriented, quality: 95);
    await File(normalizedPath).writeAsBytes(normalizedBytes);

    return NormalizedImageResult(
      normalizedPath: normalizedPath,
      image: oriented,
      width: oriented.width,
      height: oriented.height,
      isOrientationFixed: orientationFixed,
    );
  }

  /// Crops a specific ROI defined by NormalizedRect from the normalized image
  static Future<String> cropRoi({
    required img.Image baseImage,
    required NormalizedRect roi,
    required String fieldName,
  }) async {
    final rect =
        roi.toRect(baseImage.width.toDouble(), baseImage.height.toDouble());

    int x = rect.left.toInt().clamp(0, baseImage.width - 1);
    int y = rect.top.toInt().clamp(0, baseImage.height - 1);
    int w = rect.width.toInt().clamp(1, baseImage.width - x);
    int h = rect.height.toInt().clamp(1, baseImage.height - y);

    final cropped = img.copyCrop(baseImage, x: x, y: y, width: w, height: h);

    final tempDir = await getTemporaryDirectory();
    final String sanitizeName =
        fieldName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_').toLowerCase();
    final String cropPath =
        '${tempDir.path}/crop_${sanitizeName}_${DateTime.now().microsecondsSinceEpoch}.jpg';

    await File(cropPath).writeAsBytes(img.encodeJpg(cropped, quality: 95));
    return cropPath;
  }
}
