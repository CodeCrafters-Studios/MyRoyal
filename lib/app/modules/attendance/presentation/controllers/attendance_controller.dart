import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iroyal/app/modules/attendance/domain/entities/attendance_record_entity.dart';
import 'package:iroyal/app/modules/attendance/domain/usecases/get_attendance_location_usecase.dart';
import 'package:iroyal/app/modules/attendance/domain/usecases/get_attendance_today_usecase.dart';
import 'package:iroyal/app/modules/attendance/domain/usecases/record_attendance_usecase.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:latlong2/latlong.dart';

enum AttendanceStatus {
  notStarted,
  checkedIn,
  breakStart,
  breakEnd,
  checkedOut
}

extension AttendanceStatusX on AttendanceStatus {
  static AttendanceStatus fromString(String status) {
    switch (status) {
      case "checked_in":
        return AttendanceStatus.checkedIn;
      case "break_start":
        return AttendanceStatus.breakStart;
      case "break_end":
        return AttendanceStatus.breakEnd;
      case "checked_out":
        return AttendanceStatus.checkedOut;
      default:
        return AttendanceStatus.notStarted;
    }
  }
}

class AttendanceController extends GetxController {
  AttendanceController({
    required this.getAttendanceTodayUsecase,
    required this.recordAttendanceUsecase,
    required this.getAttendanceLocationUsecase,
  });

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
  final isLoadingAttendance = true.obs;

  /// ================================
  /// MAP & LOCATION
  /// ================================
  final currentPosition = Rxn<LatLng>();
  final MapController mapController = MapController();

  /// OFFICE AREA
  final officeRadius = 0.0.obs;
  final officeLocation = Rxn<LatLng>();
  final officePolygon = <LatLng>[].obs;
  final officeType = ''.obs;

  final isGpsActive = false.obs;
  final isMockLocation = false.obs;
  final isGpsSpoofing = false.obs;
  final isLocationValid = false.obs;

  Position? _previousPosition;
  StreamSubscription<Position>? _positionStream;

  /// ================================
  /// ATTENDANCE STATE
  /// ================================
  final buttonEnabled = false.obs;
  final attendanceStatus = AttendanceStatus.notStarted.obs;

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
  final workDurationMinutes = 0.obs;

  /// ================================
  /// API
  /// ================================
  final GetAttendanceTodayUsecase getAttendanceTodayUsecase;
  final RecordAttendanceUsecase recordAttendanceUsecase;
  final GetAttendanceLocationUsecase getAttendanceLocationUsecase;

  /// ================================
  /// INIT
  /// ================================
  @override
  void onInit() async {
    super.onInit();
    await _getAttendanceLocation();
    await _getAttendanceToday();
    _startTimer();
  }

  @override
  void onClose() {
    _timer.cancel();
    countingTimer?.cancel();
    _positionStream?.cancel();
    super.onClose();
  }

  /// ================================
  /// ATTENDANCE LOCATION COORDINATE
  /// ================================
  Future<void> _getAttendanceLocation() async {
    isLoadingAttendance.value = true;

    final result = await getAttendanceLocationUsecase();

    result.fold((l) {}, (r) {
      final location = r.first;

      officeType.value = location.typeArea;

      if (location.typeArea == "radius") {
        officeLocation.value = LatLng(
          location.standard.latitude,
          location.standard.longtitude,
        );

        officeRadius.value = location.standard.radius.toDouble();
      }

      if (location.typeArea == "polygon") {
        officePolygon.value =
            location.polygon.map<LatLng>((e) => LatLng(e[0], e[1])).toList();
      }
    });
  }

  bool isPointInsidePolygon(LatLng point, List<LatLng> polygon) {
    int intersectCount = 0;

    for (int j = 0; j < polygon.length - 1; j++) {
      if (((polygon[j].latitude > point.latitude) !=
              (polygon[j + 1].latitude > point.latitude)) &&
          (point.longitude <
              (polygon[j + 1].longitude - polygon[j].longitude) *
                      (point.latitude - polygon[j].latitude) /
                      (polygon[j + 1].latitude - polygon[j].latitude) +
                  polygon[j].longitude)) {
        intersectCount++;
      }
    }

    return (intersectCount % 2) == 1;
  }

  /// ================================
  /// ATTENDANCE STATUS
  /// ================================
  Future<void> _getAttendanceToday() async {
    isLoadingAttendance.value = true;

    final result = await getAttendanceTodayUsecase();

    result.fold(
      (l) {},
      (r) {
        attendanceStatus.value = AttendanceStatusX.fromString(r.status);

        if (r.checkedInTime != null) {
          final now = DateTime.now();
          final parsed = DateFormat("HH:mm:ss").parse(r.checkedInTime!);

          checkInTime.value = DateTime(
            now.year,
            now.month,
            now.day,
            parsed.hour,
            parsed.minute,
            parsed.second,
          );
        }

        if (r.checkedOutTime != null) {
          checkOutTime.value = DateFormat("HH:mm:ss").parse(r.checkedOutTime!);
        }

        if (r.breakStartTime != null) {
          breakTime.value = DateFormat("HH:mm:ss").parse(r.breakStartTime!);
          hasTakenBreak.value = true;
        }

        if (r.breakEndTime != null) {
          breakEndTime.value = DateFormat("HH:mm:ss").parse(r.breakEndTime!);
        }
      },
    );

    await _initLocation();

    isLoadingAttendance.value = false;
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
    if (officeType.value == "radius") {
      double meter = Geolocator.distanceBetween(
        currentPosition.value!.latitude,
        currentPosition.value!.longitude,
        officeLocation.value!.latitude,
        officeLocation.value!.longitude,
      );

      isLocationValid.value = meter <= officeRadius.value;
    }

    if (officeType.value == "polygon") {
      isLocationValid.value =
          isPointInsidePolygon(currentPosition.value!, officePolygon);
    }

    /// VALIDASI KELUAR RADIUS SETELAH CHECK IN
    // if (isCheckIn.value && !isLocationValid.value) {
    //   Get.snackbar(
    //     "Warning",
    //     "Anda keluar dari radius kantor!",
    //     backgroundColor: Colors.red,
    //     colorText: Colors.white,
    //   );
    // }

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

    isLoadingAttendance.value = true;

    final entity = AttendanceRecordEntity(
      status: "checked_in",
      date: DateTime.now(),
      time: DateTime.now(),
      latitude: currentPosition.value!.latitude,
      longitude: currentPosition.value!.longitude,
      workDurationMinutes: 0,
    );

    final result = await recordAttendanceUsecase(entity);

    result.fold(
      (l) {
        Get.snackbar("Error", "Check-in gagal");
        isLoadingAttendance.value = false;
      },
      (r) async {
        await _getAttendanceToday();
        isLoadingAttendance.value = false;

        Get.snackbar("Success", "Check-in successful!");
      },
    );
  }

  /// ================================
  /// CHECK OUT (RESET SEMUA)
  /// ================================
  void checkOut() {
    AppDialogImpl().showChoiceDialog(
      title: 'Confirmation',
      description: 'Are you sure want to Checkout?',
      onPressedYes: () async {
        Get.back();
        isLoadingAttendance.value = true;
        countingTimer?.cancel();

        checkOutTime.value = DateTime.now();

        _totalHours();

        final entity = AttendanceRecordEntity(
          status: "checked_out",
          date: checkOutTime.value,
          time: checkOutTime.value,
          latitude: currentPosition.value!.latitude,
          longitude: currentPosition.value!.longitude,
          workDurationMinutes: workDurationMinutes.value,
        );

        final result = await recordAttendanceUsecase(entity);

        result.fold(
          (l) {
            Get.snackbar("Error", "Check-in gagal");
            isLoadingAttendance.value = true;
          },
          (r) async {
            await _getAttendanceToday();

            countTimes.value = '--:--:--';
            myDuration = Duration.zero;
            hasTakenBreak.value = false;
            isGpsSpoofing.value = false;

            _positionStream?.cancel();
            _positionStream = null;
            isLoadingAttendance.value = true;
          },
        );
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

    workDurationMinutes.value = dif.inMinutes;
  }

  /// ================================
  /// BREAK TIME (ONLY ONCE)
  /// ================================
  void startBreakTime() async {
    if (hasTakenBreak.value) return;
    breakTime.value = DateTime.now();

    isLoadingAttendance.value = true;

    final entity = AttendanceRecordEntity(
      status: "break_start",
      date: breakTime.value,
      time: breakTime.value,
      latitude: currentPosition.value!.latitude,
      longitude: currentPosition.value!.longitude,
      workDurationMinutes: 0,
    );

    final result = await recordAttendanceUsecase(entity);

    result.fold(
      (l) {
        Get.snackbar("Error", "Gagal record Break Start");
        isLoadingAttendance.value = false;
      },
      (r) async {
        await _getAttendanceToday();

        countingTimer = Timer.periodic(
            const Duration(seconds: 1), (_) => setCountingTimer());
        isLoadingAttendance.value = false;
      },
    );
  }

  void endBreakTime() async {
    countingTimer?.cancel();

    isLoadingAttendance.value = true;

    final entity = AttendanceRecordEntity(
      status: "break_end",
      date: DateTime.now(),
      time: DateTime.now(),
      latitude: currentPosition.value!.latitude,
      longitude: currentPosition.value!.longitude,
      workDurationMinutes: 0,
    );

    final result = await recordAttendanceUsecase(entity);

    result.fold(
      (l) {
        Get.snackbar("Error", "Gagal record Break End");
        isLoadingAttendance.value = false;
      },
      (r) async {
        await _getAttendanceToday();

        Duration dif = breakEndTime.value!.difference(breakTime.value);

        String twoDigits(int n) => n.toString().padLeft(2, "0");

        breakDuration.value =
            "${twoDigits(dif.inHours)}h ${twoDigits(dif.inMinutes.remainder(60))}m";

        countTimes.value = '--:--:--';
        myDuration = Duration.zero;
        isLoadingAttendance.value = false;
      },
    );
  }

  void setCountingTimer() {
    myDuration = Duration(seconds: myDuration.inSeconds + 1);

    String twoDigits(int n) => n.toString().padLeft(2, "0");

    countTimes.value =
        "${twoDigits(myDuration.inHours)}:${twoDigits(myDuration.inMinutes.remainder(60))}:${twoDigits(myDuration.inSeconds.remainder(60))}";
  }

  bool get isCheckIn =>
      attendanceStatus.value == AttendanceStatus.checkedIn ||
      attendanceStatus.value == AttendanceStatus.breakStart ||
      attendanceStatus.value == AttendanceStatus.breakEnd;

  bool get isBreakTime => attendanceStatus.value == AttendanceStatus.breakStart;

  bool get isCheckOut => attendanceStatus.value == AttendanceStatus.checkedOut;
}
