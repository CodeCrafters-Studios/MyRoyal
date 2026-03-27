import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';

import '../controllers/validation_selfie_controller.dart';

class ValidationSelfieView extends GetView<ValidationSelfieController> {
  const ValidationSelfieView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Selfie'),
        backgroundColor: Colors.black,
      ),
      body: Obx(
        () {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final cam = controller.cameraController.value;

          if (cam == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!cam.value.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              SizedBox(
                width: Get.width,
                height: Get.height,
                child: CameraPreview(cam),
              ),
              Center(
                child: CustomPaint(
                  painter: OvalPainter(),
                  child: SizedBox(
                    width: Get.width * 0.7,
                    height: Get.height * 0.5,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 0,
                right: 0,
                child: Obx(() {
                  if (!controller.isFaceDetected.value) {
                    return Text(
                      "Align your face in the oval",
                      textAlign: TextAlign.center,
                      style: TS.bodyLarge
                          .copyWith(fontWeight: FontWeight.bold, color: red),
                    );
                  }

                  return Text(
                    "Liveness verified ✓",
                    textAlign: TextAlign.center,
                    style: TS.bodyLarge
                        .copyWith(fontWeight: FontWeight.bold, color: green),
                  );
                }),
              ),
              // Uncomment if you want manual capture button later
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Padding(
              //     padding: const EdgeInsets.all(20.0),
              //     child: FloatingActionButton(
              //       onPressed: () => controller.checkIn(), // or your capture method
              //       child: const Icon(Icons.camera),
              //     ),
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }
}

class OvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white54
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final ovalRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.7,
      height: size.height * 0.9,
    );
    canvas.drawOval(ovalRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
