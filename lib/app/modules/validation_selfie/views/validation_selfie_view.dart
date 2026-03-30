import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/validation_selfie_controller.dart';

class ValidationSelfieView extends GetView<ValidationSelfieController> {
  const ValidationSelfieView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final cam = controller.cameraController.value;

        if (cam == null ||
            !cam.value.isInitialized ||
            !controller.isCameraActive.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            Positioned.fill(
              child: ClipPath(
                clipper: OvalClipper(),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Transform.scale(
                      scale: _getOptimalScale(constraints, cam),
                      alignment: Alignment.center,
                      child: CameraPreview(cam),
                    );
                  },
                ),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: OvalOverlayPainter(),
              ),
            ),
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              child: Obx(() {
                final isDetected = controller.isFaceDetected.value;
                return Text(
                  isDetected
                      ? "Liveness verified ✓"
                      : "Move your face inside the frame",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDetected ? Colors.green : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }),
            ),
          ],
        );
      }),
    );
  }
}

class OvalOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.65);
    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.45),
      width: size.width * 0.60,
      height: size.height * 0.56,
    );

    final ovalPath = Path()..addOval(rect);
    final background = Path()
      ..addRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    final overlayPath = Path.combine(
      PathOperation.difference,
      background,
      ovalPath,
    );

    canvas.drawPath(overlayPath, overlayPaint);

    canvas.drawOval(rect, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class OvalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.45),
        width: size.width * 0.60,
        height: size.height * 0.56,
      ));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

double _getOptimalScale(
    BoxConstraints constraints, CameraController controller) {
  final previewSize = controller.value.previewSize!;

  // Tukar width/height karena preview camera biasanya landscape
  // sedangkan HP kita portrait
  final double previewHeight = previewSize.width;
  final double previewWidth = previewSize.height;

  final double screenWidth = constraints.maxWidth;
  final double screenHeight = constraints.maxHeight;

  final double scaleX = screenWidth / previewWidth;
  final double scaleY = screenHeight / previewHeight;

  // Menggunakan .max memastikan seluruh area tertutup (cover)
  return scaleX > scaleY ? scaleX : scaleY;
}
