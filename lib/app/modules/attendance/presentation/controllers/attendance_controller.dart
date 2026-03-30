import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iroyal/app/modules/attendance/data/models/attendance_location_model.dart';
import 'package:iroyal/app/modules/attendance/data/models/attendance_today_model.dart';
import 'package:iroyal/app/modules/attendance/domain/entities/attendance_record_entity.dart';
import 'package:iroyal/app/modules/attendance/domain/entities/neares_office_info_entity.dart';
import 'package:iroyal/app/modules/attendance/domain/usecases/get_attendance_location_usecase.dart';
import 'package:iroyal/app/modules/attendance/domain/usecases/get_attendance_today_usecase.dart';
import 'package:iroyal/app/modules/attendance/domain/usecases/record_attendance_usecase.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/services/http_service.dart';
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

  final currentTime = DateTime.now().obs;
  final checkInTime = DateTime.now().obs;
  final checkOutTime = DateTime.now().obs;
  final breakTime = Rxn<DateTime>();
  final breakEndTime = Rxn<DateTime>();
  final breakDuration = ''.obs;
  final hasTakenBreak = false.obs;
  final isLoadingAttendance = true.obs;
  final isMapReady = false.obs;
  final displayTime = DateTime.now().obs;

  final currentPosition = Rxn<LatLng>();
  final MapController mapController = MapController();

  RxList<AttendanceLocationModel> officeLocations =
      <AttendanceLocationModel>[].obs;
  RxList<LatLng> officePolygon = <LatLng>[].obs;
  RxList<CircleMarker> officeCircles = <CircleMarker>[].obs;
  RxList<Marker> officeMarkers = <Marker>[].obs;
  RxList<Polygon> officePolygons = <Polygon>[].obs;

  final isGpsActive = false.obs;
  final isMockLocation = false.obs;
  final isGpsSpoofing = false.obs;
  final isLocationValid = false.obs;
  final gpsAccuracy = 0.0.obs;
  final distanceFromOffice = 0.0.obs;
  final nearestOffice = Rxn<NearestOfficeInfo>();

  Position? _previousPosition;
  StreamSubscription<Position>? _positionStream;

  final buttonEnabled = false.obs;
  final attendanceStatus = AttendanceStatus.notStarted.obs;
  bool _isInitialized = false;

  Rx<AttendanceTodayModel> attendanceTodayRes =
      AttendanceTodayModel.empty().obs;

  Timer? _timer;
  Timer? breakTimer;

  RxString totalHours = ''.obs;
  DateTime? _serverTime;
  DateTime? _breakStartTime;
  DateTime? _deviceTimeAtSync;
  RxString countTimes = '--:--:--'.obs;
  final workDurationMinutes = 0.obs;

  final GetAttendanceTodayUsecase getAttendanceTodayUsecase;
  final RecordAttendanceUsecase recordAttendanceUsecase;
  final GetAttendanceLocationUsecase getAttendanceLocationUsecase;

  @override
  void onInit() {
    super.onInit();

    final httpService = Get.find<HttpService>();

    ever(httpService.connectionStatus, (String status) {
      if (status == "No connection") {
        isLoadingAttendance.value = true;
      } else {
        _runInitialOnce();
      }
    });

    _runInitialOnce();
  }

  @override
  void onClose() {
    _timer?.cancel();
    breakTimer?.cancel();
    _positionStream?.cancel();

    super.onClose();
  }

  void _runInitialOnce() {
    if (_isInitialized) return;

    final httpService = Get.find<HttpService>();

    if (httpService.connectionStatus.value == "No connection") return;

    _isInitialized = true;
    _loadInitialData();
  }

  void _loadInitialData() async {
    if (attendanceStatus.value == AttendanceStatus.notStarted) {
      countTimes.value = '--:--:--';
      hasTakenBreak.value = false;
      breakTime.value = null;
      breakEndTime.value = null;
      breakDuration.value = '';
      countTimes.value = '--:--:--';

      _getAttendanceLocation();
    }

    await _getAttendanceToday();
    _startTimer();
  }

  Future<void> onRefresh() async {
    _loadInitialData();
    if (isMapReady.value) {
      _fitMapBounds(officeCircles.map((c) => c.point).toList() +
          officePolygons.expand((p) => p.points).toList());
    }
  }

  Future<void> _getAttendanceLocation() async {
    isLoadingAttendance.value = true;
    final result = await getAttendanceLocationUsecase();

    result.fold((l) {
      final error = l.properties.first;

      if (error is ApiException) {
        AppUtils.logApp('SERVER ERROR ::: ${error.message}');
      } else {
        AppUtils.logApp('SERVER ERROR ::: $error');
      }
    }, (r) {
      final List<AttendanceLocationModel> locations = r;

      officeLocations.assignAll(locations);

      officeCircles.clear();
      officeMarkers.clear();
      officePolygon.clear();

      final List<LatLng> boundPoints = [];

      for (final loc in locations) {
        LatLng? markerPoint;

        if (loc.typeArea == "radius") {
          final lat = loc.stkamurd.latitude;
          final lng = loc.stkamurd.longtitude;

          AppUtils.logApp('RADIUS LAT :::: $lat');
          AppUtils.logApp('RADIUS LONG :::: $lng');

          markerPoint = LatLng(lat, lng);

          officeCircles.add(
            CircleMarker(
              point: markerPoint,
              radius: loc.stkamurd.radius * 1.0,
              useRadiusInMeter: true,
              color: isLocationValid.value
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              borderColor: isLocationValid.value ? Colors.green : Colors.red,
              borderStrokeWidth: 2,
            ),
          );

          boundPoints.add(markerPoint);
        }

        if (loc.typeArea == "polygon") {
          final polygonPoints =
              loc.polygon.map((e) => LatLng(e[0], e[1])).toList();

          officePolygons.add(
            Polygon(
              points: polygonPoints,
              color: isLocationValid.value
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              borderColor: isLocationValid.value ? Colors.green : Colors.red,
              borderStrokeWidth: 2,
            ),
          );

          boundPoints.addAll(polygonPoints);
          markerPoint = polygonPoints.first;
        }

        if (markerPoint != null) {
          officeMarkers.add(
            Marker(
              point: markerPoint,
              width: 40,
              height: 40,
              child: const Icon(
                Icons.location_city,
                color: Colors.blue,
                size: 35,
              ),
            ),
          );
        }
      }

      _fitMapBounds(boundPoints);
      _updateOfficeColors();
    });

    isLoadingAttendance.value = false;
  }

  void _fitMapBounds(List<LatLng> points) {
    if (!isMapReady.value) {
      Future.delayed(const Duration(milliseconds: 200), () {
        _fitMapBounds(points);
      });
      return;
    }

    final bounds = LatLngBounds.fromPoints(points);

    mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(40),
        maxZoom: 18,
      ),
    );
  }

  bool isPointInsidePolygon(LatLng point, List<LatLng> polygon) {
    bool inside = false;

    for (int i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
      final xi = polygon[i].longitude;
      final yi = polygon[i].latitude;

      final xj = polygon[j].longitude;
      final yj = polygon[j].latitude;

      final intersect = ((yi > point.latitude) != (yj > point.latitude)) &&
          (point.longitude <
              (xj - xi) * (point.latitude - yi) / (yj - yi) + xi);

      if (intersect) inside = !inside;
    }

    return inside;
  }

  Future<void> _getAttendanceToday() async {
    isLoadingAttendance.value = true;

    final result = await getAttendanceTodayUsecase();

    result.fold(
      (l) {},
      (r) {
        attendanceTodayRes.value = r;
        attendanceStatus.value = AttendanceStatusX.fromString(r.status);

        final now = DateTime.now();

        if (r.checkedInTime != null) {
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
          final parsed = DateFormat("HH:mm:ss").parse(r.checkedOutTime!);
          checkOutTime.value = DateTime(
            now.year,
            now.month,
            now.day,
            parsed.hour,
            parsed.minute,
            parsed.second,
          );
        }

        if (r.breakStartTime != null && r.serverTime != null) {
          final parsed = DateFormat("HH:mm:ss").parse(r.breakStartTime!);

          breakTime.value = DateTime(
            now.year,
            now.month,
            now.day,
            parsed.hour,
            parsed.minute,
            parsed.second,
          );

          startBreakTimerFromServer(
            r.serverTime!,
            r.breakStartTime!,
          );
        }

        if (r.breakEndTime != null) {
          final parsed = DateFormat("HH:mm:ss").parse(r.breakEndTime!);
          breakEndTime.value = DateTime(
            now.year,
            now.month,
            now.day,
            parsed.hour,
            parsed.minute,
            parsed.second,
          );
        }

        if (r.checkedOutTime != null && r.checkedInTime != null) {
          _totalHours();
        }

        if (r.breakEndTime != null && r.breakStartTime != null) {
          final dif = breakEndTime.value!.difference(breakTime.value!);
          String twoDigits(int n) => n.toString().padLeft(2, "0");
          breakDuration.value =
              "${twoDigits(dif.inHours)}h ${twoDigits(dif.inMinutes.remainder(60))}m";
        }
      },
    );

    await _initLocation();
    isLoadingAttendance.value = false;
  }

  Future<void> _initLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    isGpsActive.value = serviceEnabled;

    AppUtils.logApp("GPS ENABLED: $serviceEnabled");

    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) return;

    _startLocationStream();
  }

  void _startLocationStream() {
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 2,
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

  void _handleLocationUpdate(Position newPosition) {
    isGpsActive.value = true;
    isMockLocation.value = newPosition.isMocked;
    gpsAccuracy.value = newPosition.accuracy;

    if (isMockLocation.value) {
      isGpsSpoofing.value = true;
    }

    if (newPosition.accuracy > 40) {
      isLocationValid.value = false;
      buttonEnabled.value = false;
      _updateOfficeColors();
      return;
    }

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
        if (speed > 30) {
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

    currentPosition.value = LatLng(newPosition.latitude, newPosition.longitude);

    try {
      if (_previousPosition != null) {
        Geolocator.distanceBetween(
          _previousPosition!.latitude,
          _previousPosition!.longitude,
          newPosition.latitude,
          newPosition.longitude,
        );

        // if (moved > 10) {
        //   mapController.move(currentPosition.value!, 17);
        // }
      }
    } catch (_) {}

    _previousPosition = newPosition;
    bool valid = false;
    double nearestDistance = double.infinity;

    for (final circle in officeCircles) {
      final meter = Geolocator.distanceBetween(
        currentPosition.value!.latitude,
        currentPosition.value!.longitude,
        circle.point.latitude,
        circle.point.longitude,
      );

      if (meter < nearestDistance) {
        nearestDistance = meter;
      }

      final tolerance = min(gpsAccuracy.value, 10);

      if (meter <= circle.radius + tolerance) {
        valid = true;
      }
    }

    distanceFromOffice.value = nearestDistance;

    if (!valid) {
      for (final poly in officePolygons) {
        if (isPointInsidePolygon(currentPosition.value!, poly.points)) {
          valid = true;
          break;
        }
      }
    }

    isLocationValid.value = valid;
    buttonEnabled.value = isLocationValid.value && !isGpsSpoofing.value;

    _updateOfficeColors();
    _calculateNearestOffice(currentPosition.value!);
  }

  void _startTimer() {
    if (_timer?.isActive ?? false) return;

    final serverTimeStr = attendanceTodayRes.value.serverTime;

    if (serverTimeStr == null || serverTimeStr.isEmpty) {
      return;
    }

    DateTime parsed;

    try {
      parsed = DateFormat("HH:mm:ss").parse(serverTimeStr);
    } catch (e) {
      AppUtils.logApp("INVALID SERVER TIME: $serverTimeStr");
      return;
    }

    final now = DateTime.now();

    _serverTime = DateTime(
      now.year,
      now.month,
      now.day,
      parsed.hour,
      parsed.minute,
      parsed.second,
    );

    _deviceTimeAtSync = now;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final nowDevice = DateTime.now();
      final elapsed = nowDevice.difference(_deviceTimeAtSync!);

      final currentServerTime = _serverTime!.add(elapsed);

      displayTime.value = currentServerTime;
    });
  }

  Future<void> validationSelfie(String status) async {
    if (!isLocationValid.value) {
      AppDialogImpl().showErrorSnackBar(
          description: "Anda harus berada di dalam radius kantor.");
      return;
    }

    if (isGpsSpoofing.value) {
      AppDialogImpl().showErrorSnackBar(description: "Fake GPS terdeteksi!");
      return;
    }

    final result = await Get.toNamed(
      Routes.VALIDATION_SELFIE,
      arguments: [
        status,
        attendanceTodayRes.value,
        currentPosition.value,
      ],
    );

    if (result == true && status == 'checked_in') {
      await _getAttendanceToday();
    } else {
      _totalHours();
      await _getAttendanceToday();
      isGpsSpoofing.value = false;
      _positionStream?.cancel();
      _positionStream = null;
    }
  }

  void _totalHours() {
    breakTimer?.cancel();
    checkOutTime.value = DateTime.now();

    Duration dif = checkOutTime.value.difference(checkInTime.value);

    if (breakEndTime.value != null && breakTime.value != null) {
      dif -= breakEndTime.value!.difference(breakTime.value!);
    }

    String twoDigits(int n) => n.toString().padLeft(2, "0");

    totalHours.value =
        "${twoDigits(dif.inHours)}h ${twoDigits(dif.inMinutes.remainder(60))}m";

    workDurationMinutes.value = dif.inMinutes;
  }

  void startBreakTime() async {
    if (hasTakenBreak.value) return;

    breakTime.value = DateTime.now();
    breakDuration.value = '';
    isLoadingAttendance.value = true;

    final entity = AttendanceRecordEntity(
      id: attendanceTodayRes.value.attendanceId!,
      status: "break_start",
      date: breakTime.value!,
      time: breakTime.value!,
      latitude: currentPosition.value!.latitude,
      longitude: currentPosition.value!.longitude,
      workDurationMinutes: 0,
      file: '',
    );

    final result = await recordAttendanceUsecase(entity);

    result.fold(
      (l) {
        Get.snackbar("Error", "Gagal record Break Start");
        isLoadingAttendance.value = false;
      },
      (r) async {
        await _getAttendanceToday();
        isLoadingAttendance.value = false;
      },
    );
  }

  void startBreakTimerFromServer(String serverTime, String breakStart) {
    if (serverTime.isEmpty || breakStart.isEmpty) return;

    try {
      final now = DateTime.now();

      final server = DateFormat("HH:mm:ss").parse(serverTime);
      final start = DateFormat("HH:mm:ss").parse(breakStart);

      _serverTime = DateTime(now.year, now.month, now.day, server.hour,
          server.minute, server.second);

      _breakStartTime = DateTime(
          now.year, now.month, now.day, start.hour, start.minute, start.second);

      _deviceTimeAtSync = now;

      _runBreakTimer();
    } catch (e) {
      AppUtils.logApp("ERROR PARSE BREAK TIME: $e");
    }
  }

  void _runBreakTimer() {
    breakTimer?.cancel();

    if (_serverTime == null ||
        _breakStartTime == null ||
        _deviceTimeAtSync == null) {
      return;
    }

    breakTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        final nowDevice = DateTime.now();
        final deviceElapsed = nowDevice.difference(_deviceTimeAtSync!);
        final serverNow = _serverTime!.add(deviceElapsed);
        final breakDuration = serverNow.difference(_breakStartTime!);

        countTimes.value = _formatDuration(breakDuration);
      },
    );
  }

  void endBreakTime() async {
    breakTimer?.cancel();

    isLoadingAttendance.value = true;

    final entity = AttendanceRecordEntity(
      id: attendanceTodayRes.value.attendanceId!,
      status: "break_end",
      date: DateTime.now(),
      time: DateTime.now(),
      latitude: currentPosition.value!.latitude,
      longitude: currentPosition.value!.longitude,
      workDurationMinutes: 0,
      file: '',
    );

    final result = await recordAttendanceUsecase(entity);

    result.fold(
      (l) {
        Get.snackbar("Error", "Gagal record Break End");
        isLoadingAttendance.value = false;
      },
      (r) async {
        await _getAttendanceToday();

        if (breakEndTime.value != null && breakTime.value != null) {
          Duration dif = breakEndTime.value!.difference(breakTime.value!);

          String twoDigits(int n) => n.toString().padLeft(2, "0");

          breakDuration.value =
              "${twoDigits(dif.inHours)}h ${twoDigits(dif.inMinutes.remainder(60))}m";
        }

        breakTimer?.cancel();
        countTimes.value = '--:--:--';
        isLoadingAttendance.value = false;
      },
    );
  }

  void _updateOfficeColors() {
    final isInside = isLocationValid.value;

    final fillColor =
        isInside ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2);

    final borderColor = isInside ? Colors.green : Colors.red;

    // Update semua circle
    final newCircles = officeCircles
        .map((c) => CircleMarker(
              point: c.point,
              radius: c.radius,
              useRadiusInMeter: true,
              color: fillColor,
              borderColor: borderColor,
              borderStrokeWidth: 2,
            ))
        .toList();
    officeCircles.assignAll(newCircles);

    // Update semua polygon
    final newPolygons = officePolygons
        .map((p) => Polygon(
              points: p.points,
              color: fillColor,
              borderColor: borderColor,
              borderStrokeWidth: 2,
            ))
        .toList();
    officePolygons.assignAll(newPolygons);
  }

  void _calculateNearestOffice(LatLng userPos) {
    double nearestDistance = double.infinity;
    NearestOfficeInfo? nearest;

    for (final loc in officeLocations) {
      if (loc.typeArea == "radius") {
        final lat = double.tryParse(loc.stkamurd.latitude.toString()) ?? 0.0;
        final lng = double.tryParse(loc.stkamurd.longtitude.toString()) ?? 0.0;

        final center = LatLng(lat, lng);

        final centerDistance = Geolocator.distanceBetween(
          userPos.latitude,
          userPos.longitude,
          center.latitude,
          center.longitude,
        );

        final radius = loc.stkamurd.radius.toDouble();

        final inside = centerDistance <= radius;

        final boundaryDistance = inside ? 0.0 : centerDistance - radius;

        if (centerDistance < nearestDistance) {
          nearestDistance = centerDistance;

          nearest = NearestOfficeInfo(
            locationName: loc.location,
            type: "radius",
            distanceToCenter: centerDistance,
            distanceToBoundary: boundaryDistance,
            radius: radius,
            inside: inside,
          );
        }
      }

      if (loc.typeArea == "polygon") {
        final polygonPoints =
            loc.polygon.map((e) => LatLng(e[0], e[1])).toList();

        final inside = isPointInsidePolygon(userPos, polygonPoints);

        final boundaryDistance =
            _distanceToPolygonBoundary(userPos, polygonPoints);

        if (boundaryDistance < nearestDistance) {
          nearestDistance = boundaryDistance;

          nearest = NearestOfficeInfo(
            locationName: loc.location,
            type: "polygon",
            distanceToCenter: boundaryDistance,
            distanceToBoundary: inside ? 0.0 : boundaryDistance,
            radius: 0,
            inside: inside,
          );
        }
      }
    }

    nearestOffice.value = nearest;
  }

  void centerToUserLocation() {
    final pos = currentPosition.value;

    if (pos == null) return;

    mapController.move(
      LatLng(pos.latitude, pos.longitude),
      18,
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    return "${twoDigits(duration.inHours)}:"
        "${twoDigits(duration.inMinutes.remainder(60))}:"
        "${twoDigits(duration.inSeconds.remainder(60))}";
  }

  bool get isCheckIn =>
      attendanceStatus.value == AttendanceStatus.checkedIn ||
      attendanceStatus.value == AttendanceStatus.breakStart ||
      attendanceStatus.value == AttendanceStatus.breakEnd;

  bool get isBreakTime => attendanceStatus.value == AttendanceStatus.breakStart;

  bool get isCheckOut => attendanceStatus.value == AttendanceStatus.checkedOut;

  double _distanceToPolygonBoundary(LatLng point, List<LatLng> polygon) {
    double minDistance = double.infinity;

    for (int i = 0; i < polygon.length; i++) {
      final p1 = polygon[i];
      final p2 = polygon[(i + 1) % polygon.length];

      final distance = Geolocator.distanceBetween(
        point.latitude,
        point.longitude,
        (p1.latitude + p2.latitude) / 2,
        (p1.longitude + p2.longitude) / 2,
      );

      if (distance < minDistance) {
        minDistance = distance;
      }
    }

    return minDistance;
  }

  String get formattedDisplayTime {
    if (attendanceStatus.value == AttendanceStatus.breakStart) {
      return countTimes.value;
    } else if (attendanceStatus.value == AttendanceStatus.checkedOut) {
      return DateFormat('hh:mm:ss a').format(checkOutTime.value);
    }

    return DateFormat('hh:mm:ss a').format(displayTime.value);
  }
}
