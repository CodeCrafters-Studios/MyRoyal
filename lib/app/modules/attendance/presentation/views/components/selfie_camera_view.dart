import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:iroyal/app/modules/attendance/presentation/controllers/attendance_controller.dart';

class SelfieCameraView extends GetView<AttendanceController> {
  const SelfieCameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Selfie'),
        backgroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.cameraController.value == null ||
            !controller.cameraController.value!.value.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }
        return Stack(
          children: [
            SizedBox(
              width: Get.width,
              height: Get.height,
              child: CameraPreview(controller.cameraController.value!),
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
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: FloatingActionButton(
                  onPressed: () async {
                    try {
                      final photo = await controller.cameraController.value!
                          .takePicture();
                      controller.takenPhoto.value = File(photo.path);

                      // controller.isCheckIn.value = true;
                      controller.checkInTime.value = DateTime.now();

                      Get.back();

                      Get.snackbar('Success', 'Check-in successful!');
                    } catch (e) {
                      Get.snackbar('Error', 'Failed to take a photo: $e');
                    }
                  },
                  child: const Icon(Icons.camera),
                ),
              ),
            ),
          ],
        );
      }),
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
