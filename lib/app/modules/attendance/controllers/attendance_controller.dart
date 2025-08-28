import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:iroyal/app/modules/attendance/views/components/selfie_camera_view.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class AttendanceController extends GetxController {
  final currentTime = DateTime.now().obs;
  final checkInTime = DateTime.now().obs;
  final checkOutTime = DateTime.now().obs;
  final breakTime = DateTime.now().obs;
  final Completer<GoogleMapController> mapCompleter = Completer();
  final currentPosition = Rxn<LatLng>();
  final locationError = RxnString();
  final officeLocation = const LatLng(-6.8617228, 107.5010659);
  final officeRadius = 10.0;

  RxBool isCheckIn = false.obs;
  RxBool isCheckOut = false.obs;
  RxBool isBreakTime = false.obs;
  RxBool isLocationValid = false.obs;
  RxBool isFacingCamera = false.obs;
  final cameras = RxList<CameraDescription>();
  final cameraController = Rxn<CameraController>();
  final takenPhoto = Rxn<File>();
  final buttonEnabled = false.obs;

  RxString totalHours = ''.obs;
  RxString countTimes = '--:--:--'.obs;

  late Timer _timer;
  Timer? countingTimer;
  Duration myDuration = const Duration();

  Position? _previousPosition;
  final isGpsSpoofing = false.obs;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
    _checkPermissions();
  }

  @override
  void onClose() {
    super.onClose();
    _timer.cancel();
    cameraController.value?.dispose();
  }

  Future<void> _checkPermissions() async {
    var cameraStatus = await Permission.camera.request();

    if (cameraStatus.isGranted) {
      _initCamera();
      _startLocationStream();
    } else {
      Get.snackbar('Permission Denied',
          'Please grant camera permissions to use this feature.');
    }
  }

  Future<void> _initCamera() async {
    try {
      cameras.value = await availableCameras();
      final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front);
      cameraController.value = CameraController(
          frontCamera, ResolutionPreset.high,
          enableAudio: false);
      await cameraController.value!.initialize();
      isFacingCamera.value = true;
    } catch (e) {
      AppUtils.logApp('Error initializing camera: $e');
    }
  }

  void _startLocationStream() {
    Geolocator.getPositionStream(
            locationSettings:
                const LocationSettings(accuracy: LocationAccuracy.best))
        .listen((Position position) {
      _handleLocationUpdate(position);
    });
  }

  void _handleLocationUpdate(Position newPosition) {
    if (_previousPosition != null) {
      final distance = Geolocator.distanceBetween(
        _previousPosition!.latitude,
        _previousPosition!.longitude,
        newPosition.latitude,
        newPosition.longitude,
      );
      final timeDifference = newPosition.timestamp
          .difference(_previousPosition!.timestamp)
          .inSeconds;

      if (timeDifference > 0 && distance / timeDifference > 100) {
        isGpsSpoofing.value = true;
        buttonEnabled.value = false;
        Get.snackbar('Location Tampering Detected!',
            'Your attendance cannot be recorded due to suspicious location changes.');
        return;
      }
    }

    _previousPosition = newPosition;
    currentPosition.value = LatLng(newPosition.latitude, newPosition.longitude);

    double distance = Geolocator.distanceBetween(
      currentPosition.value!.latitude,
      currentPosition.value!.longitude,
      officeLocation.latitude,
      officeLocation.longitude,
    );
    isLocationValid.value = distance <= officeRadius;

    buttonEnabled.value =
        isLocationValid.value && isFacingCamera.value && !isGpsSpoofing.value;
  }

  void onMapCreated(GoogleMapController controller) {
    if (!mapCompleter.isCompleted) {
      mapCompleter.complete(controller);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      currentTime.value = DateTime.now();
    });
  }

  Future<void> checkIn() async {
    if (!isLocationValid.value) {
      Get.snackbar(
          'Gagal Check In', 'Anda harus berada di dalam radius kantor.');
      return;
    }

    await Get.to(() => SelfieCameraView());
  }

  void checkOut() {
    AppDialogImpl().showChoiceDialog(
      title: 'Confirmation',
      description: 'Are you sure want to Checkout?',
      onPressedYes: () {
        Get.back();
        isCheckOut.value = true;
        checkOutTime.value = DateTime.now();
        _timer.cancel();
        _totalHours();
      },
    );
  }

  void _totalHours() {
    AppUtils.logApp(DateFormat('hh:mm a').format(checkInTime.value));
    AppUtils.logApp(DateFormat('hh:mm a').format(checkOutTime.value));

    Duration dif = checkOutTime.value.difference(checkInTime.value);

    AppUtils.logApp(dif.toString());
    AppUtils.logApp(dif.toString().substring(0, 4));

    String negativeSign = dif.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(dif.inMinutes.remainder(60).abs());

    totalHours.value =
        "$negativeSign${twoDigits(dif.inHours)}h ${twoDigitMinutes}m";

    AppUtils.logApp(totalHours.value);
  }

  void startBreakTime() {
    isBreakTime.value = true;
    breakTime.value = DateTime.now();
    _startCountingTimer();
  }

  void _startCountingTimer() {
    countingTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountingTimer());
  }

  void endBreakTime() {
    countingTimer!.cancel();
    countTimes.value = '--:--:--';
    isBreakTime.value = false;
    myDuration = Duration.zero;

    AppUtils.logApp(countTimes.value);
    AppUtils.logApp('$myDuration');
  }

  void setCountingTimer() {
    const addSecondsBy = 1;
    final countSeconds = myDuration.inSeconds + addSecondsBy;
    myDuration = Duration(seconds: countSeconds);

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(myDuration.inHours.remainder(24));
    final minutes = twoDigits(myDuration.inMinutes.remainder(60));
    final seconds = twoDigits(myDuration.inSeconds.remainder(60));

    countTimes.value = "$hours:$minutes:$seconds";

    AppUtils.logApp(countTimes.value);
  }
}
