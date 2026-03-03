import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:latlong2/latlong.dart';

class AttendanceController extends GetxController {
  /// ================================
  /// TIME STATE
  /// ================================
  final currentTime = DateTime.now().obs;
  final checkInTime = DateTime.now().obs;
  final checkOutTime = DateTime.now().obs;
  final breakTime = DateTime.now().obs;
  final breakEndTime = Rxn<DateTime>();
  final breakDuration = ''.obs;
  final hasTakenBreak = false.obs;

  /// ================================
  /// MAP & LOCATION
  /// ================================
  final currentPosition = Rxn<LatLng>();
  final MapController mapController = MapController();
  final officeLocation = const LatLng(-6.8617228, 107.5010659);
  final officeRadius = 50.0;

  final isGpsActive = false.obs;
  final isMockLocation = false.obs;
  final isGpsSpoofing = false.obs;
  final isLocationValid = false.obs;

  Position? _previousPosition;
  StreamSubscription<Position>? _positionStream;

  /// ================================
  /// ATTENDANCE STATE
  /// ================================
  RxBool isCheckIn = false.obs;
  RxBool isCheckOut = false.obs;
  RxBool isBreakTime = false.obs;
  final buttonEnabled = false.obs;

  /// ================================
  /// CAMERA
  /// ================================
  RxBool isFacingCamera = false.obs;
  final cameras = RxList<CameraDescription>();
  final cameraController = Rxn<CameraController>();
  final takenPhoto = Rxn<File>();

  /// ================================
  /// TIMER
  /// ================================
  late Timer _timer;
  Timer? countingTimer;
  Duration myDuration = Duration.zero;
  RxString totalHours = ''.obs;
  RxString countTimes = '--:--:--'.obs;

  /// ================================
  /// INIT
  /// ================================
  @override
  void onInit() {
    super.onInit();
    _startTimer();
    _initLocation();
  }

  @override
  void onClose() {
    _timer.cancel();
    countingTimer?.cancel();
    _positionStream?.cancel();
    super.onClose();
  }

  /// ================================
  /// INIT LOCATION
  /// ================================
  Future<void> _initLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    isGpsActive.value = serviceEnabled;

    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) return;

    _startLocationStream();
  }

  /// ================================
  /// LOCATION STREAM (LIVE + AUTO CENTER)
  /// ================================
  void _startLocationStream() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 5,
    );

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
      _handleLocationUpdate,
      onError: (error) {
        isGpsActive.value = false;
        AppUtils.logApp("Location Stream Error: $error");
      },
    );
  }

  /// ================================
  /// HANDLE LOCATION UPDATE
  /// ================================
  void _handleLocationUpdate(Position newPosition) {
    isGpsActive.value = true;

    /// MOCK GPS DETECTION
    isMockLocation.value = newPosition.isMocked;
    if (isMockLocation.value) {
      isGpsSpoofing.value = true;
    }

    /// JUMP / SPEED DETECTION
    if (_previousPosition != null) {
      final distance = Geolocator.distanceBetween(
        _previousPosition!.latitude,
        _previousPosition!.longitude,
        newPosition.latitude,
        newPosition.longitude,
      );

      final timeDiff = newPosition.timestamp
          .difference(_previousPosition!.timestamp)
          .inSeconds;

      if (timeDiff > 0) {
        final speed = distance / timeDiff;

        if (speed > 60) {
          isGpsSpoofing.value = true;
          Get.snackbar(
            "Suspicious Movement",
            "Pergerakan tidak wajar terdeteksi",
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      }
    }

    _previousPosition = newPosition;

    currentPosition.value = LatLng(newPosition.latitude, newPosition.longitude);

    /// AUTO CENTER MAP
    try {
      mapController.move(currentPosition.value!, 17);
    } catch (_) {}

    /// CHECK RADIUS
    double meter = Geolocator.distanceBetween(
      currentPosition.value!.latitude,
      currentPosition.value!.longitude,
      officeLocation.latitude,
      officeLocation.longitude,
    );

    isLocationValid.value = meter <= officeRadius;

    /// VALIDASI KELUAR RADIUS SETELAH CHECK IN
    if (isCheckIn.value && !isLocationValid.value) {
      Get.snackbar(
        "Warning",
        "Anda keluar dari radius kantor!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    buttonEnabled.value =
        isLocationValid.value && isFacingCamera.value && !isGpsSpoofing.value;
  }

  /// ================================
  /// TIMER
  /// ================================
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      currentTime.value = DateTime.now();
    });
  }

  /// ================================
  /// CHECK IN
  /// ================================
  Future<void> checkIn() async {
    if (!isLocationValid.value) {
      Get.snackbar("Gagal", "Anda harus berada di dalam radius kantor.");
      return;
    }

    if (isGpsSpoofing.value) {
      Get.snackbar("Gagal", "Fake GPS terdeteksi!");
      return;
    }

    isCheckIn.value = true;
    checkInTime.value = DateTime.now();

    Get.snackbar("Success", "Check-in successful!");
  }

  /// ================================
  /// CHECK OUT (RESET SEMUA)
  /// ================================
  void checkOut() {
    AppDialogImpl().showChoiceDialog(
      title: 'Confirmation',
      description: 'Are you sure want to Checkout?',
      onPressedYes: () {
        countingTimer?.cancel();

        isCheckOut.value = true;
        isBreakTime.value = false;
        hasTakenBreak.value = false;
        isGpsSpoofing.value = false;

        checkOutTime.value = DateTime.now();

        breakDuration.value = '';
        countTimes.value = '--:--:--';
        myDuration = Duration.zero;

        _totalHours();
        Get.back();
      },
    );
  }

  /// ================================
  /// TOTAL HOURS
  /// ================================
  void _totalHours() {
    Duration dif = checkOutTime.value.difference(checkInTime.value);

    String twoDigits(int n) => n.toString().padLeft(2, "0");

    totalHours.value =
        "${twoDigits(dif.inHours)}h ${twoDigits(dif.inMinutes.remainder(60))}m";
  }

  /// ================================
  /// BREAK TIME (ONLY ONCE)
  /// ================================
  void startBreakTime() {
    if (hasTakenBreak.value) return;

    breakTime.value = DateTime.now();
    isBreakTime.value = true;
    hasTakenBreak.value = true;

    countingTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountingTimer());
  }

  void endBreakTime() {
    countingTimer?.cancel();

    breakEndTime.value = DateTime.now();

    Duration dif = breakEndTime.value!.difference(breakTime.value);

    String twoDigits(int n) => n.toString().padLeft(2, "0");

    breakDuration.value =
        "${twoDigits(dif.inHours)}h ${twoDigits(dif.inMinutes.remainder(60))}m";

    countTimes.value = '--:--:--';
    isBreakTime.value = false;
    myDuration = Duration.zero;
  }

  void setCountingTimer() {
    myDuration = Duration(seconds: myDuration.inSeconds + 1);

    String twoDigits(int n) => n.toString().padLeft(2, "0");

    countTimes.value =
        "${twoDigits(myDuration.inHours)}:${twoDigits(myDuration.inMinutes.remainder(60))}:${twoDigits(myDuration.inSeconds.remainder(60))}";
  }
}
