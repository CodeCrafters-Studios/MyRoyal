import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/widgets/buttons/button_primary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

import '../controllers/ocr_controller.dart';

class OcrView extends GetView<OcrController> {
  const OcrView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('OcrView2'),
          centerTitle: true,
        ),
        body: Obx(() => controller.isLoadingOCR.value
            ? _buildReadingPage(context)
            : controller.isLoadingOCR.value == false &&
                    controller.isDataLoaded.value
                ? _buildInfoPage(context)
                : Container(
                    color: const Color(0xFF0F1720),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          'Scan KTP (Depan)',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Posisikan bagian depan KTP di dalam bingkai hingga seluruh informasi terlihat jelas.',
                          style: TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 18),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Obx(() {
                              if (!controller.isCameraInitialized.value ||
                                  controller.cameraController == null) {
                                return Container(
                                  color: Colors.black,
                                  child: const Center(
                                      child: CircularProgressIndicator()),
                                );
                              }
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  CameraPreview(controller.cameraController!),
                                  AnimatedBuilder(
                                    animation: controller.animationController,
                                    builder: (context, child) {
                                      return CustomPaint(
                                        painter: ScannerOverlayPainter(
                                            animationValue: controller
                                                .animationController.value),
                                      );
                                    },
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Tips:',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              _buildTip('Jaga jarak kamera sekitar 20–30 cm'),
                              _buildTip('Pastikan seluruh bagian KTP terlihat'),
                              _buildTip('Hindari jari menutupi tepi KTP'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildBottomAction(
                                Icons.photo_library,
                                'Galeri',
                                () =>
                                    controller.pickImage(ImageSource.gallery)),
                            Column(
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: Gradients.gold(),
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () =>
                                          controller.takePictureFromCamera(),
                                      borderRadius: BorderRadius.circular(36),
                                      child: const Icon(Icons.camera_alt,
                                          size: 36, color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text('Scan',
                                    style: TextStyle(color: Colors.white70)),
                              ],
                            ),
                            Obx(() => _buildBottomAction(
                                controller.isFlashOn.value
                                    ? Icons.flash_on
                                    : Icons.flash_off,
                                'Flash',
                                controller.toggleFlash)),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  )));
  }

  Widget _buildBottomAction(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(40),
          child: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.black87),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF00AFA6), size: 20),
          const SizedBox(width: 8),
          Expanded(
              child: Text(text, style: const TextStyle(color: Colors.white70))),
        ],
      ),
    );
  }

  Widget _buildReadingPage(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            const Text('Pembacaan KTP',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.credit_card,
                        size: 56, color: Color(0xFF00AFA6)),
                  ),
                  const SizedBox(height: 24),
                  const Text('Sedang Membaca KTP',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  const Text('Mohon tunggu beberapa saat...',
                      style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 24),
                  Obx(() => LinearProgressIndicator(
                      value: controller.readingProgress.value,
                      color: const Color(0xFF00AFA6),
                      backgroundColor: Colors.grey[200])),
                  const SizedBox(height: 8),
                  Align(
                      alignment: Alignment.centerRight,
                      child: Obx(() => Text(
                          '${(controller.readingProgress.value * 100).round()}%'))),
                ],
              ),
            ),
            Card(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: const [
                    Icon(Icons.auto_awesome, color: Color(0xFF00AFA6)),
                    SizedBox(width: 12),
                    Expanded(
                        child: Text(
                            'OCR sedang mengekstrak data dari KTP Anda. Jangan tutup aplikasi selama proses berlangsung')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPage(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                        'Data berhasil dibaca. Silakan periksa kembali data Anda',
                        style: TextStyle(color: Colors.black87)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Form(
              key: controller.formKey,
              child: Column(
                children: [
                  _buildInput('Nama Lengkap', controller.nameController),
                  _buildInput('NIK', controller.nikController,
                      keyboardType: TextInputType.number),
                  Row(
                    children: [
                      Expanded(
                          child: _buildInput(
                              'Tempat Lahir', controller.birthPlaceController)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: _buildInput(
                              'Tanggal Lahir', controller.birthDateController)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildInput('Jenis Kelamin', controller.genderController),
                  const SizedBox(height: 8),
                  _buildInput('Alamat', controller.addressController,
                      maxLines: 2),
                  Row(
                    children: [
                      Expanded(
                          child: _buildInput('RT', controller.rtController)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: _buildInput('RW', controller.rwController)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                          child: _buildInput(
                              'Kelurahan/Desa', controller.villageController)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: _buildInput(
                              'Kecamatan', controller.districtController)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                          child: _buildInput(
                              'Agama', controller.religionController)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: _buildInput('Status Perkawinan',
                              controller.maritalStatusController)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                          child: _buildInput(
                              'Pekerjaan', controller.workController)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: _buildInput('Kewarganegaraan',
                              controller.nationalityController)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _buildInput('Email', TextEditingController(),
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 8),
                  _buildInput('Nomor Handphone', controller.phoneController,
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: controller.retake,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: Color(0xFF00AFA6)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Retake',
                              style: TextStyle(
                                  color: Color(0xFF00AFA6),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ButtonPrimary(
                            fullWidth: true,
                            text: 'Submit',
                            onPressed: controller.submitData),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller,
      {int maxLines = 1, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        readOnly: true,
        style: const TextStyle(color: Colors.black54),
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          isDense: true,
        ),
        validator: (v) => (v == null || v.isEmpty) ? 'Mohon diisi' : null,
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  final double animationValue;
  ScannerOverlayPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final frameWidth = size.width * 0.82;
    final frameHeight = frameWidth / 1.586;
    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: frameWidth,
      height: frameHeight,
    );
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));

    // Draw dark overlay with clear cutout
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.65);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), overlayPaint);
    final cutoutPaint = Paint()..blendMode = BlendMode.clear;
    canvas.drawRRect(rrect, cutoutPaint);
    canvas.restore();

    // Pulsing opacity between 0.4 and 1.0 based on animationValue
    final cornerOpacity = 0.4 + (0.6 * animationValue);
    final paint = Paint()
      ..color = const Color(0xFF3B82F6).withOpacity(cornerOpacity)
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double cornerLength = 28.0;
    const double radius = 12.0;

    final left = rect.left;
    final top = rect.top;
    final right = rect.right;
    final bottom = rect.bottom;

    // Top-Left
    final pathTL = Path()
      ..moveTo(left, top + cornerLength)
      ..lineTo(left, top + radius)
      ..arcToPoint(Offset(left + radius, top),
          radius: const Radius.circular(radius))
      ..lineTo(left + cornerLength, top);
    canvas.drawPath(pathTL, paint);

    // Top-Right
    final pathTR = Path()
      ..moveTo(right - cornerLength, top)
      ..lineTo(right - radius, top)
      ..arcToPoint(Offset(right, top + radius),
          radius: const Radius.circular(radius))
      ..lineTo(right, top + cornerLength);
    canvas.drawPath(pathTR, paint);

    // Bottom-Left
    final pathBL = Path()
      ..moveTo(left, bottom - cornerLength)
      ..lineTo(left, bottom - radius)
      ..arcToPoint(Offset(left + radius, bottom),
          radius: const Radius.circular(radius), clockwise: false)
      ..lineTo(left + cornerLength, bottom);
    canvas.drawPath(pathBL, paint);

    // Bottom-Right
    final pathBR = Path()
      ..moveTo(right - cornerLength, bottom)
      ..lineTo(right - radius, bottom)
      ..arcToPoint(Offset(right, bottom - radius),
          radius: const Radius.circular(radius), clockwise: false)
      ..lineTo(right, bottom - cornerLength);
    canvas.drawPath(pathBR, paint);
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
