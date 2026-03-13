import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:intl/intl.dart';
import 'package:iroyal/app/modules/attendance/data/models/attendance_record_model.dart';
import 'package:iroyal/app/modules/attendance/data/models/attendance_today_model.dart';
import 'package:iroyal/app/modules/attendance/domain/usecases/record_attendance_usecase.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

class ValidationSelfieController extends GetxController {
  ValidationSelfieController({
    required this.recordAttendanceUsecase,
  });

  final RecordAttendanceUsecase recordAttendanceUsecase;

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true,
      enableTracking: true,
      performanceMode: FaceDetectorMode.fast,
    ),
  );
  bool _isProcessing = false;
  RxBool isFaceDetected = false.obs;

  bool _captured = false;

  bool _isCameraActive = true;
  DateTime? _lastRun;
  RxBool isFacingCamera = false.obs;
  RxBool isLoading = false.obs;
  String status = '';

  final cameras = RxList<CameraDescription>();
  final cameraController = Rxn<CameraController>();
  final takenPhoto = Rxn<File>();
  final currentPosition = Rxn<LatLng>();

  Rx<AttendanceTodayModel> attendanceTodayRes =
      AttendanceTodayModel.empty().obs;

  @override
  void onInit() {
    super.onInit();
    status = Get.arguments[0];
    attendanceTodayRes.value = Get.arguments[1];
    currentPosition.value = Get.arguments[2];
  }

  @override
  void onReady() {
    super.onReady();
    _checkPermission();
  }

  @override
  void onClose() {
    _isCameraActive = false;
    cameraController.value?.dispose();
    _faceDetector.close();
    super.onClose();
  }

  Future<String> convertImageToBase64(File imageFile) async {
    final bytes = await imageFile.readAsBytes();

    final sizeKB = bytes.length / 1024;
    print("IMAGE ORIGINAL SIZE: ${sizeKB.toStringAsFixed(2)} KB");

    final base64Image = base64Encode(bytes);

    final base64SizeKB = base64Image.length / 1024;
    print("BASE64 SIZE: ${base64SizeKB.toStringAsFixed(2)} KB");

    return base64Image;
  }

  Future<void> _checkPermission() async {
    var cameraStatus = await Permission.camera.request();

    if (cameraStatus.isGranted) {
      await Future.delayed(const Duration(milliseconds: 200));
      _initCamera();
    } else {
      AppDialogImpl().showErrorSnackBar(
          description: 'Please grant camera permission to use this feature.');
    }
  }

  Future<void> _initCamera() async {
    if (_captured) return;

    try {
      cameras.value = await availableCameras();

      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      final controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.yuv420
            : ImageFormatGroup.bgra8888,
      );

      cameraController.value = controller;

      await controller.initialize();

      cameraController.refresh();

      if (!controller.value.isStreamingImages) {
        controller.startImageStream(_processCameraImage);
      }

      isFacingCamera.value = true;
    } catch (e) {
      AppUtils.logApp("Camera init failed: $e");
      AppDialogImpl().showErrorSnackBar(description: "Gagal membuka kamera");
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (!_isCameraActive) return;
    if (_captured) return;
    if (_isProcessing) return;
    if (cameraController.value == null) return;
    if (_lastRun != null &&
        DateTime.now().difference(_lastRun!) <
            const Duration(milliseconds: 300)) {
      return;
    }

    if (!cameraController.value!.value.isStreamingImages) return;

    _isProcessing = true;

    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }

      final bytes = allBytes.done().buffer.asUint8List();

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotation.rotation0deg,
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes.first.bytesPerRow,
        ),
      );

      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        isFaceDetected.value = false;
        return;
      }

      if (faces.length > 1) return;

      final face = faces.first;
      if (face.boundingBox.width < 200) return;

      isFaceDetected.value = true;

      await Future.delayed(Duration(milliseconds: 400));

      await _autoCapture();
    } catch (e) {
      AppUtils.logApp('ERROR LIVENESS $e');
    } finally {
      _lastRun = DateTime.now();
      _isProcessing = false;
    }
  }

  Future<void> _autoCapture() async {
    _isCameraActive = false;

    final cam = cameraController.value;
    if (cam == null) return;

    if (cam.value.isStreamingImages) {
      await cam.stopImageStream();
    }

    await Future.delayed(const Duration(milliseconds: 200));

    final photo = await cam.takePicture();
    takenPhoto.value = File(photo.path);

    await Future.delayed(const Duration(milliseconds: 700));

    await _disposeCamera();

    recordAttendance(status);
  }

  Future<void> _disposeCamera() async {
    try {
      final cam = cameraController.value;
      if (cam == null) return;

      if (cam.value.isStreamingImages) {
        await cam.stopImageStream();
      }

      await cam.dispose();
      cameraController.value = null;
    } catch (e) {
      AppUtils.logApp("Dispose camera error: $e");
    }
  }

  Future<void> recordAttendance(String status) async {
    isLoading.value = true;

    final photo = takenPhoto.value;

    if (photo == null) {
      print("PHOTO NULL");
      return;
    }

    final base64Image = await convertImageToBase64(photo);

    final entity = AttendanceRecordModel(
      id: attendanceTodayRes.value.attendanceId!,
      status: status,
      date: DateTime.now(),
      time: DateFormat("HH:mm:ss").parse(attendanceTodayRes.value.serverTime!),
      latitude: currentPosition.value!.latitude,
      longitude: currentPosition.value!.longitude,
      workDurationMinutes: 0,
      file: "image/png;base64,$base64Image",
    );

    final json = entity.toJson();

    print(
        "REQUEST JSON SIZE: ${(jsonEncode(json).length / 1024).toStringAsFixed(2)} KB");
    print(json);

    final result = await recordAttendanceUsecase(entity);

    result.fold(
      (l) {
        AppDialogImpl().showErrorSnackBar(description: "Check-in gagal");
        isLoading.value = false;
      },
      (r) async {
        Get.back(result: true);
        isLoading.value = false;

        AppDialogImpl().showSuccessSnackBar(
          description: status == 'checked_in'
              ? 'Check-in successful!'
              : 'Check-out successful!',
        );
      },
    );
  }
}
