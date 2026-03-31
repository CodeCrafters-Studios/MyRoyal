import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:MyRoyal/app/modules/attendance/domain/entities/neares_office_info_entity.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:intl/intl.dart';
import 'package:MyRoyal/app/modules/attendance/data/models/attendance_record_model.dart';
import 'package:MyRoyal/app/modules/attendance/data/models/attendance_today_model.dart';
import 'package:MyRoyal/app/modules/attendance/domain/usecases/record_attendance_usecase.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';
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

  RxBool isCameraActive = true.obs;
  DateTime? _lastRun;
  RxBool isFacingCamera = false.obs;
  RxBool isLoading = false.obs;
  String status = '';
  int _faceMissCount = 0;
  int _faceHitCount = 0;

  final cameras = RxList<CameraDescription>();
  final cameraController = Rxn<CameraController>();
  final takenPhoto = Rxn<File>();
  final currentPosition = Rxn<LatLng>();
  final debugFaceRect = Rxn<Rect>();
  NearestOfficeInfo? nearestOffice;

  Rx<AttendanceTodayModel> attendanceTodayRes =
      AttendanceTodayModel.empty().obs;

  @override
  void onInit() {
    super.onInit();
    status = Get.arguments[0];
    attendanceTodayRes.value = Get.arguments[1];
    currentPosition.value = Get.arguments[2];
    nearestOffice = Get.arguments[3];
  }

  @override
  void onReady() {
    super.onReady();
    _checkPermission();
  }

  @override
  void onClose() {
    isCameraActive.value = false;
    cameraController.value?.dispose();
    _faceDetector.close();
    super.onClose();
  }

  Future<String> convertImageToBase64(File imageFile) async {
    final filePath = imageFile.absolute.path;
    final outPath = "${filePath}_compressed.jpg";

    final XFile? compressedXFile =
        await FlutterImageCompress.compressAndGetFile(
      filePath,
      outPath,
      minWidth: 480,
      minHeight: 640,
      quality: 75,
      format: CompressFormat.jpeg,
    );

    if (compressedXFile == null) return "";

    final bytes = await compressedXFile.readAsBytes();

    final sizeKB = bytes.length / 1024;
    print("COMPRESSED IMAGE SIZE: ${sizeKB.toStringAsFixed(2)} KB");

    final base64Image = base64Encode(bytes);

    final base64SizeKB = base64Image.length / 1024;
    print("BASE64 REQUEST SIZE: ${base64SizeKB.toStringAsFixed(2)} KB");

    File(outPath).delete();

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
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      cameraController.value = controller;

      AppUtils.logApp(
          'SENSOR orientation: ${cameraController.value!.description.sensorOrientation}');
      AppUtils.logApp(
          'LENS direction: ${cameraController.value!.description.lensDirection}');
      AppUtils.logApp(
          'DEVICE orientation: ${cameraController.value!.value.deviceOrientation}');
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
    if (!isCameraActive.value || _captured || _isProcessing) return;

    if (_lastRun != null &&
        DateTime.now().difference(_lastRun!) <
            const Duration(milliseconds: 200)) return;

    _isProcessing = true;

    try {
      final inputFormat = Platform.isAndroid
          ? InputImageFormat.nv21
          : InputImageFormat.bgra8888;

      final rotation = _getInputImageRotation();

      final WriteBuffer allBytes = WriteBuffer();
      for (Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }

      final bytes = allBytes.done().buffer.asUint8List();

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: inputFormat,
          bytesPerRow: image.planes.first.bytesPerRow,
        ),
      );

      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        _faceMissCount++;
        _faceHitCount = 0;

        if (_faceMissCount > 5) {
          isFaceDetected.value = false;
        }
        return;
      }

      final face = faces.first;

      final isInside = _isFaceInsideFrame(
        rotation: rotation,
        faceRect: face.boundingBox,
        imageSize: Size(image.width.toDouble(), image.height.toDouble()),
      );

      if (isInside) {
        _faceHitCount++;
        _faceMissCount = 0;

        if (_faceHitCount > 2) {
          isFaceDetected.value = true;
        }

        if (_faceHitCount > 5 && !_captured) {
          _captured = true;
          _autoCapture();
        }
      } else {
        _faceMissCount++;

        if (_faceMissCount > 3) {
          isFaceDetected.value = false;
        }
      }
    } catch (e) {
      AppUtils.logApp('ERROR LIVENESS $e');
    } finally {
      _lastRun = DateTime.now();
      _isProcessing = false;
    }
  }

  InputImageRotation _getInputImageRotation() {
    final cam = cameraController.value;
    if (cam == null) return InputImageRotation.rotation90deg;

    final sensorOrientation = cam.description.sensorOrientation;

    if (Platform.isIOS) {
      return InputImageRotation.rotation0deg;
    }

    switch (sensorOrientation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation90deg;
    }
  }

  bool _isFaceInsideFrame({
    required Rect faceRect,
    required Size imageSize,
    required InputImageRotation rotation,
  }) {
    final screenW = Get.width;
    final screenH = Get.height;

    double left = faceRect.left / imageSize.width;
    double top = faceRect.top / imageSize.height;
    double right = faceRect.right / imageSize.width;
    double bottom = faceRect.bottom / imageSize.height;

    double nx = (left + right) / 2;
    double ny = (top + bottom) / 2;

    nx = 1 - nx;

    final cam = cameraController.value!;
    final previewSize = cam.value.previewSize!;
    final previewW = previewSize.height;
    final previewH = previewSize.width;

    final scale = math.max(screenW / previewW, screenH / previewH);
    final displayW = previewW * scale;
    final displayH = previewH * scale;
    final offsetX = (screenW - displayW) / 2;
    final offsetY = (screenH - displayH) / 2;

    final px = nx * displayW + offsetX;
    final py = ny * displayH + offsetY;

    debugFaceRect.value =
        Rect.fromCenter(center: Offset(px, py), width: 10, height: 10);

    final ovalFrame = Rect.fromCenter(
      center: Offset(screenW / 2, screenH * 0.45),
      width: screenW * 0.60,
      height: screenH * 0.56,
    );

    return ovalFrame.inflate(30).contains(Offset(px, py));
  }

  Future<void> _autoCapture() async {
    isCameraActive.value = false;

    final cam = cameraController.value;

    if (cam == null) return;

    if (cam.value.isStreamingImages) {
      await cam.stopImageStream();
    }

    await Future.delayed(const Duration(milliseconds: 200));

    final photo = await cam.takePicture();
    takenPhoto.value = File(photo.path);

    await _disposeCamera();

    recordAttendance(status);
  }

  Future<void> _disposeCamera() async {
    try {
      isCameraActive.value = false;

      final cam = cameraController.value;
      if (cam == null) return;

      if (cam.value.isStreamingImages) {
        await cam.stopImageStream();
      }

      await Future.delayed(const Duration(milliseconds: 100));

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
      locationID: nearestOffice?.locationId ?? 0,
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
        AppDialogImpl().showErrorSnackBar(
            description:
                status == 'checked_in' ? "Checkin gagal" : "Checkout gagal");
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
