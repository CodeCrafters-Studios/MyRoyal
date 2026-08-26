import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as img;

class OcrQualityReport {
  final double score;
  final bool isAcceptable;
  final double blurScore;
  final double brightnessScore;
  final double glareScore;
  final double resolutionScore;
  final double? skewScore;

  const OcrQualityReport({
    required this.score,
    required this.isAcceptable,
    required this.blurScore,
    required this.brightnessScore,
    required this.glareScore,
    required this.resolutionScore,
    this.skewScore,
  });

  @override
  String toString() {
    return 'OcrQualityReport(score: ${score.toStringAsFixed(2)}, acceptable: $isAcceptable, blur: ${blurScore.toStringAsFixed(2)}, bright: ${brightnessScore.toStringAsFixed(2)}, glare: ${glareScore.toStringAsFixed(2)}, res: ${resolutionScore.toStringAsFixed(2)})';
  }
}

class OcrQualityAnalyzer {
  static const double _minimumAcceptableScore = 0.55;

  static Future<OcrQualityReport> analyze(String imagePath) async {
    final file = File(imagePath);
    if (!await file.exists()) {
      return const OcrQualityReport(
        score: 0,
        isAcceptable: false,
        blurScore: 0,
        brightnessScore: 0,
        glareScore: 0,
        resolutionScore: 0,
      );
    }

    final bytes = await file.readAsBytes();
    final img.Image? decoded = img.decodeImage(bytes);
    if (decoded == null) {
      return const OcrQualityReport(
        score: 0,
        isAcceptable: false,
        blurScore: 0,
        brightnessScore: 0,
        glareScore: 0,
        resolutionScore: 0,
      );
    }

    final blurScore = _estimateLaplacianBlurScore(decoded);
    final brightnessScore = _estimateBrightness(decoded);
    final glareScore = _estimateGlare(decoded);
    final resolutionScore = _estimateResolution(decoded);

    // Dynamic weighted score using only active, reliable metrics (omitting unmeasured skew)
    final double score = (0.45 * blurScore) +
        (0.20 * brightnessScore) +
        (0.20 * glareScore) +
        (0.15 * resolutionScore);

    final clampedScore = math.max(0.0, math.min(1.0, score));

    return OcrQualityReport(
      score: clampedScore,
      isAcceptable: clampedScore >= _minimumAcceptableScore,
      blurScore: blurScore,
      brightnessScore: brightnessScore,
      glareScore: glareScore,
      resolutionScore: resolutionScore,
      skewScore:
          null, // Excluded as it cannot be reliably calculated on raw unsegmented image
    );
  }

  /// Calculates focus/sharpness using Laplacian Variance edge detection metric
  static double _estimateLaplacianBlurScore(img.Image image) {
    final gray = img.grayscale(image.clone());
    // Downscale for speed if very large
    final processingImage =
        gray.width > 800 ? img.copyResize(gray, width: 800) : gray;

    final w = processingImage.width;
    final h = processingImage.height;
    if (w < 3 || h < 3) return 0.5;

    final laplacianValues = <double>[];

    // Compute 3x3 Laplacian convolution kernel response: [0, 1, 0; 1, -4, 1; 0, 1, 0]
    for (int y = 1; y < h - 1; y += 2) {
      for (int x = 1; x < w - 1; x += 2) {
        final center = processingImage.getPixel(x, y).r;
        final top = processingImage.getPixel(x, y - 1).r;
        final bottom = processingImage.getPixel(x, y + 1).r;
        final left = processingImage.getPixel(x - 1, y).r;
        final right = processingImage.getPixel(x + 1, y).r;

        final lap = (top + bottom + left + right - (4 * center)).toDouble();
        laplacianValues.add(lap);
      }
    }

    if (laplacianValues.isEmpty) return 0.5;

    final mean =
        laplacianValues.reduce((a, b) => a + b) / laplacianValues.length;
    double variance = 0.0;
    for (final val in laplacianValues) {
      variance += math.pow(val - mean, 2).toDouble();
    }
    variance /= laplacianValues.length;

    // Empirical Laplacian variance thresholding for document text sharpness
    // > 150 = sharp, < 30 = very blurry
    final double normalizedBlur = (variance / 150.0).clamp(0.0, 1.0);
    return normalizedBlur;
  }

  static double _estimateBrightness(img.Image image) {
    final mean = _meanLum(image);
    if (mean < 60) {
      // Too dark
      return (mean / 60.0).clamp(0.1, 0.6);
    } else if (mean > 220) {
      // Overexposed
      return (1.0 - ((mean - 220) / 35.0)).clamp(0.2, 0.7);
    }
    return 1.0;
  }

  static double _estimateGlare(img.Image image) {
    int overexposedPixels = 0;
    int totalSampled = 0;

    for (int y = 0; y < image.height; y += 4) {
      for (int x = 0; x < image.width; x += 4) {
        final pixel = image.getPixel(x, y);
        if (pixel.r > 245 && pixel.g > 245 && pixel.b > 245) {
          overexposedPixels++;
        }
        totalSampled++;
      }
    }

    if (totalSampled == 0) return 0.9;
    final glareRatio = overexposedPixels / totalSampled;

    if (glareRatio > 0.15) return 0.2;
    if (glareRatio > 0.05) return 0.6;
    return 1.0;
  }

  static double _estimateResolution(img.Image image) {
    final area = image.width * image.height;
    if (area >= 1200000) return 1.0; // e.g. 1280x960+
    if (area >= 600000) return 0.85; // e.g. 1000x600+
    if (area >= 300000) return 0.60;
    return 0.30;
  }

  static double _meanLum(img.Image image) {
    double total = 0.0;
    int count = 0;
    for (int y = 0; y < image.height; y += 4) {
      for (int x = 0; x < image.width; x += 4) {
        final p = image.getPixel(x, y);
        total += (0.299 * p.r + 0.587 * p.g + 0.114 * p.b);
        count++;
      }
    }
    return count == 0 ? 128.0 : total / count;
  }
}
