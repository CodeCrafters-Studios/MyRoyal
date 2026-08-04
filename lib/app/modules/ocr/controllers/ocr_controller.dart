import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:developer' as developer;

class OcrController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxBool isLoadingOCR = false.obs;
  RxBool isDataLoaded = false.obs;
  RxDouble readingProgress = 0.0.obs;

  CameraController? cameraController;
  RxBool isCameraInitialized = false.obs;
  RxBool isFlashOn = false.obs;

  late AnimationController animationController;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat(reverse: true);
    initCamera();
  }

  Future<void> initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        cameraController = CameraController(
          cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.back,
              orElse: () => cameras.first),
          ResolutionPreset.high,
          enableAudio: false,
        );
        await cameraController!.initialize();
        isCameraInitialized.value = true;
      }
    } catch (e) {
      developer.log("Error initializing camera: $e");
    }
  }

  void toggleFlash() {
    if (cameraController != null && cameraController!.value.isInitialized) {
      isFlashOn.value = !isFlashOn.value;
      cameraController!
          .setFlashMode(isFlashOn.value ? FlashMode.torch : FlashMode.off);
    }
  }

  Future<void> takePictureFromCamera() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      try {
        final XFile image = await cameraController!.takePicture();
        await processImage(image.path);
      } catch (e) {
        developer.log("Error taking picture: $e");
        Get.snackbar('Error', 'Gagal mengambil gambar');
      }
    }
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController birthPlaceController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController rtController = TextEditingController();
  final TextEditingController rwController = TextEditingController();
  final TextEditingController villageController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController religionController = TextEditingController();
  final TextEditingController maritalStatusController = TextEditingController();
  final TextEditingController workController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  @override
  void dispose() {
    nameController.dispose();
    nikController.dispose();
    birthPlaceController.dispose();
    birthDateController.dispose();
    genderController.dispose();
    addressController.dispose();
    rtController.dispose();
    rwController.dispose();
    villageController.dispose();
    districtController.dispose();
    religionController.dispose();
    maritalStatusController.dispose();
    workController.dispose();
    nationalityController.dispose();
    phoneController.dispose();
    _textRecognizer.close();
    cameraController?.dispose();
    animationController.dispose();
    super.dispose();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image =
          await _picker.pickImage(source: source, imageQuality: 80);
      if (image != null) {
        await processImage(image.path);
      }
    } catch (e) {
      developer.log("Error picking image: $e");
      Get.snackbar('Error', 'Gagal memuat gambar');
    }
  }

  Future<void> processImage(String imagePath) async {
    isLoadingOCR.value = true;
    isDataLoaded.value = false;
    readingProgress.value = 0.2;

    try {
      final InputImage inputImage = InputImage.fromFilePath(imagePath);
      readingProgress.value = 0.5;

      final RecognizedText recognizedText =
          await _textRecognizer.processImage(inputImage);
      readingProgress.value = 0.8;

      parseKtpText(recognizedText.text);

      readingProgress.value = 1.0;
      await Future.delayed(
          const Duration(milliseconds: 500)); // Smooth progress transition
      isDataLoaded.value = true;
    } catch (e) {
      developer.log("Error processing image: $e");
      Get.snackbar('Error', 'Gagal memproses gambar KTP');
    } finally {
      isLoadingOCR.value = false;
      readingProgress.value = 0.0;
    }
  }

  void parseKtpText(String text) {
    developer.log("OCR Result:\n$text");
    List<String> lines = text
        .split('\n')
        .map((e) => e.toUpperCase().trim())
        .where((e) => e.isNotEmpty)
        .toList();

    // Clear previous data
    nikController.clear();
    nameController.clear();
    birthPlaceController.clear();
    birthDateController.clear();
    genderController.clear();
    addressController.clear();
    rtController.clear();
    rwController.clear();
    villageController.clear();
    districtController.clear();
    religionController.clear();
    maritalStatusController.clear();
    workController.clear();
    nationalityController.clear();

    bool isPekerjaanNext = false;
    bool isAgamaNext = false;

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i].replaceAll(RegExp(r'\s+'), ' ');

      // Fix NIK (16 chars)
      if (nikController.text.isEmpty) {
        RegExp nikRegex = RegExp(r'\b[0-9A-Z]{16}\b');
        Match? match = nikRegex.firstMatch(line.replaceAll(' ', ''));
        if (match != null) {
          String rawNik = match.group(0)!;
          int digits = RegExp(r'[0-9]').allMatches(rawNik).length;
          if (digits >= 10) {
            nikController.text = rawNik
                .replaceAll('O', '0')
                .replaceAll('L', '1')
                .replaceAll('I', '1')
                .replaceAll('B', '6')
                .replaceAll('S', '5')
                .replaceAll('Z', '2')
                .replaceAll('G', '6');

            // Assume Nama is the next line
            if (i + 1 < lines.length && nameController.text.isEmpty) {
              String nextLine = lines[i + 1];
              if (!nextLine.contains('TEMPAT') &&
                  !nextLine.contains('LAHIR') &&
                  !nextLine.contains('NAMA')) {
                nameController.text = nextLine;
              }
            }
            continue;
          }
        }
      }

      // Tempat/Tgl Lahir
      RegExp ttlRegex =
          RegExp(r'([A-Z\s]+),\s*([0-9]{2}[\-\.\s/][0-9]{2}[\-\.\s/][0-9]{4})');
      Match? ttlMatch = ttlRegex.firstMatch(line);
      if (ttlMatch != null) {
        birthPlaceController.text = ttlMatch.group(1)!.trim();
        birthDateController.text =
            ttlMatch.group(2)!.replaceAll(RegExp(r'[\.\s/]'), '-');
      }

      // Gender
      if (line.contains('LAKI') ||
          line.contains('LAK-LAKI') ||
          line.contains('LAK!')) {
        genderController.text = 'LAKI-LAKI';
      } else if (line.contains('PEREMPUAN') || line.contains('PEREM')) {
        genderController.text = 'PEREMPUAN';
      }

      // RT/RW and Alamat/Desa/Kecamatan heuristc
      RegExp rtrwRegex = RegExp(r'([0-9O]{3})\s*[/I1l]\s*([0-9O]{3})');
      Match? rtrwMatch = rtrwRegex.firstMatch(line);
      if (rtrwMatch != null) {
        rtController.text = rtrwMatch.group(1)!.replaceAll('O', '0');
        rwController.text = rtrwMatch.group(2)!.replaceAll('O', '0');

        if (i - 1 >= 0 && addressController.text.isEmpty) {
          String prev = lines[i - 1];
          if (!prev.contains('LAKI') &&
              !prev.contains('PEREMPUAN') &&
              !prev.contains('19') &&
              !prev.contains('20') &&
              !prev.contains('ALAMAT')) {
            addressController.text = prev;
          }
        }
        if (i + 1 < lines.length && villageController.text.isEmpty) {
          String next = lines[i + 1]
              .replaceAll('KEL/DESA', '')
              .replaceAll(':', '')
              .trim();
          if (next.isNotEmpty && !next.contains('KECAMATAN'))
            villageController.text = next;
        }
        if (i + 2 < lines.length && districtController.text.isEmpty) {
          String next2 = lines[i + 2]
              .replaceAll('KECAMATAN', '')
              .replaceAll(':', '')
              .trim();
          if (next2.isNotEmpty && !next2.contains('AGAMA'))
            districtController.text = next2;
        }
      }

      // Agama
      if (line.contains('ISLAM') || line.contains('ISUAM'))
        religionController.text = 'ISLAM';
      else if (line.contains('KATHOLIK') || line.contains('KATOLIK'))
        religionController.text = 'KATHOLIK';
      else if (line.contains('KRISTEN'))
        religionController.text = 'KRISTEN';
      else if (line.contains('HINDU'))
        religionController.text = 'HINDU';
      else if (line.contains('BUDHA'))
        religionController.text = 'BUDHA';
      else if (line.contains('KONGHUCU')) religionController.text = 'KONGHUCU';

      // Marital Status
      if (line.contains('BELUM KAWIN'))
        maritalStatusController.text = 'BELUM KAWIN';
      else if (line.contains('CERAI HIDUP'))
        maritalStatusController.text = 'CERAI HIDUP';
      else if (line.contains('CERAI MATI'))
        maritalStatusController.text = 'CERAI MATI';
      else if (line.contains('KAWIN') && !line.contains('BELUM'))
        maritalStatusController.text = 'KAWIN';

      // WNI/WNA
      if (line.contains('WNI'))
        nationalityController.text = 'WNI';
      else if (line.contains('WNA')) nationalityController.text = 'WNA';

      // Pekerjaan
      if (line.contains('BURUH') ||
          line.contains('SWASTA') ||
          line.contains('WIRASWASTA') ||
          line.contains('PELAJAR') ||
          line.contains('MAHASISWA') ||
          line.contains('MENGURUS') ||
          line.contains('PEGAWAI') ||
          line.contains('TENTARA') ||
          line.contains('POLISI') ||
          line.contains('PENSIUNAN') ||
          line.contains('PEDAGANG') ||
          line.contains('PETANI') ||
          line.contains('DOSEN') ||
          line.contains('GURU')) {
        workController.text =
            line.replaceAll(RegExp(r'PEKERJAAN\s*:?'), '').trim();
      }

      // Deferred Label Matching (if label and value are on different lines)
      if (line == 'PEKERJAAN')
        isPekerjaanNext = true;
      else if (isPekerjaanNext &&
          !line.contains('KEWARGANEGARAAN') &&
          !line.contains('BERLAKU') &&
          !line.contains('GOL')) {
        workController.text = line;
        isPekerjaanNext = false;
      }

      if (line == 'AGAMA')
        isAgamaNext = true;
      else if (isAgamaNext && !line.contains('STATUS')) {
        religionController.text = line;
        isAgamaNext = false;
      }

      // Inline Label matching fallback for remaining fields
      if (line.contains('NAMA') && nameController.text.isEmpty) {
        String val = extractValue(line, 'NAMA');
        if (val.isNotEmpty) nameController.text = val;
      }
      if (line.contains('ALAMAT') && addressController.text.isEmpty) {
        String val = extractValue(line, 'ALAMAT');
        if (val.isNotEmpty) addressController.text = val;
      }
      if (line.contains('KEL/DESA') && villageController.text.isEmpty) {
        String val = extractValue(line, 'KEL/DESA');
        if (val.isNotEmpty) villageController.text = val;
      }
      if (line.contains('KECAMATAN') && districtController.text.isEmpty) {
        String val = extractValue(line, 'KECAMATAN');
        if (val.isNotEmpty) districtController.text = val;
      }
    }
  }

  String extractValue(String line, String keyword) {
    int index = line.indexOf(keyword);
    if (index != -1) {
      String value = line.substring(index + keyword.length).trim();
      if (value.startsWith(':')) {
        value = value.substring(1).trim();
      }
      return value.replaceAll(RegExp(r'^[:\-\.\s]+'), '');
    }
    return '';
  }

  void retake() {
    isDataLoaded.value = false;
  }

  void submitData() {
    if (formKey.currentState?.validate() ?? false) {
      // Implement API call logic here
      Get.snackbar('Sukses', 'Data berhasil dikirim ke server');
    }
  }
}
