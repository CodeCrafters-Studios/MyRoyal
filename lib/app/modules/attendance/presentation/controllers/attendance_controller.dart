import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:MyRoyal/app/modules/attendance/data/models/attendance_location_model.dart';
import 'package:MyRoyal/app/modules/attendance/data/models/attendance_today_model.dart';
import 'package:MyRoyal/app/modules/attendance/domain/entities/attendance_record_entity.dart';
import 'package:MyRoyal/app/modules/attendance/domain/entities/neares_office_info_entity.dart';
import 'package:MyRoyal/app/modules/attendance/domain/usecases/get_attendance_location_usecase.dart';
import 'package:MyRoyal/app/modules/attendance/domain/usecases/get_attendance_today_usecase.dart';
import 'package:MyRoyal/app/modules/attendance/domain/usecases/record_attendance_usecase.dart';
import 'package:MyRoyal/app/routes/app_pages.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/services/http_service.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';
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

class AttendanceController extends GetxController with WidgetsBindingObserver {
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

  // ── Indoor GPS accuracy improvements ──────────────────────────────────────
  // Upper floors reflect GPS signals, causing 40–70 m reported accuracy.
  // We compensate with: a position buffer, relaxed thresholds, and debouncing.

  /// Buffer of recent valid fixes used for weighted-average smoothing.
  final List<Position> _positionBuffer = [];

  /// How many consecutive "valid" readings before we enable check-in.
  int _validStreak = 0;

  /// How many consecutive "invalid" readings before we disable check-in.
  int _invalidStreak = 0;

  /// Reject only fixes with accuracy worse than this (metres).
  /// Raised from 40 m → 65 m because indoor/upper-floor GPS is routinely 40–60 m.
  static const double _kAccuracyRejectThreshold = 65.0;

  /// Maximum geofence tolerance added on top of the office radius/boundary (metres).
  /// Accounts for floor-elevation GPS drift in multi-storey buildings.
  static const double _kMaxTolerance = 25.0;

  /// Building-specific indoor buffer (metres) added regardless of reported accuracy.
  /// Tuned for GEDUNG B (r=34 m) and GEDUNG A (~80×60 m polygon).
  static const double _kBuildingBuffer = 15.0;

  /// Rolling window size for weighted-average position smoothing.
  static const int _kPositionBufferSize = 5;

  /// Consecutive valid reads required before isLocationValid → true.
  static const int _kValidStreakRequired = 2;

  /// Consecutive invalid reads required before isLocationValid → false.
  static const int _kInvalidStreakRequired = 3;

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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initLocation();
    }
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

    if (!serviceEnabled) {
      _showEnableGpsDialog();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      _showPermissionDialog();
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      _showPermissionSettingsDialog();
      return;
    }

    _startLocationStream();
  }

  void _showEnableGpsDialog() {
    AppDialogImpl().showInfoDialog(
        title: "GPS Tidak Aktif",
        description: "Mohon aktifkan GPS untuk melanjutkan absensi.",
        textButton: "Buka Pengaturan",
        onPress: () async {
          Get.back();
          await Geolocator.openLocationSettings();
          await _initLocation();
        });
  }

  void _showPermissionDialog() {
    Get.defaultDialog(
      title: "Izin Lokasi Dibutuhkan",
      middleText: "Aplikasi membutuhkan akses lokasi.",
      textConfirm: "Izinkan",
      onConfirm: () async {
        Get.back();
        await Geolocator.requestPermission();
      },
    );
  }

  void _showPermissionSettingsDialog() {
    Get.defaultDialog(
      title: "Izin Ditolak Permanen",
      middleText: "Silakan aktifkan izin lokasi melalui pengaturan aplikasi.",
      textConfirm: "Buka Pengaturan",
      textCancel: "Batal",
      onConfirm: () async {
        Get.back();
        await Geolocator.openAppSettings();
      },
    );
  }

  void _startLocationStream() {
    // LocationAccuracy.best uses raw GNSS averaging — better for indoors than
    // bestForNavigation (which is tuned for outdoor pedestrian/vehicle use).
    // distanceFilter: 0 ensures every fix reaches the buffer for smoothing.
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0,
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

    // ── 1. Hard-reject only extremely noisy fixes ──────────────────────────
    // Raised from 40 m → 65 m: indoor/upper-floor GPS routinely reports 40–60 m.
    // Fixes worse than 65 m are too unstable to use for any calculation.
    if (newPosition.accuracy > _kAccuracyRejectThreshold) {
      AppUtils.logApp(
          'GPS fix rejected (accuracy ${newPosition.accuracy.toStringAsFixed(1)} m > ${_kAccuracyRejectThreshold} m threshold)');
      return;
    }

    // ── 2. Spoofing detection via speed ───────────────────────────────────
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

    _previousPosition = newPosition;

    // ── 3. Rolling position buffer for weighted-average smoothing ─────────
    // Reduces outlier spikes caused by a single bad GPS fix.
    _positionBuffer.add(newPosition);
    if (_positionBuffer.length > _kPositionBufferSize) {
      _positionBuffer.removeAt(0);
    }

    // Use the smoothed position for all geofence checks.
    final smoothedPos = _computeWeightedPosition();
    currentPosition.value = smoothedPos;

    // ── 4. Indoor-aware tolerance ─────────────────────────────────────────
    // Old formula: min(accuracy, 10) — way too tight for upper-floor drift.
    // New formula: scales with accuracy up to _kMaxTolerance, plus a fixed
    // building buffer (_kBuildingBuffer) for multi-storey GPS drift.
    // GEDUNG B radius=34 m → max effective zone ≈ 34+25+15 = 74 m.
    // GEDUNG A ~80×60 m polygon → boundary buffer up to 40 m.
    final tolerance =
        min(newPosition.accuracy * 0.6, _kMaxTolerance) + _kBuildingBuffer;

    AppUtils.logApp(
        'GPS smoothed | acc=${newPosition.accuracy.toStringAsFixed(1)} m | tolerance=${tolerance.toStringAsFixed(1)} m');

    bool valid = false;
    double nearestDistance = double.infinity;

    // ── Circle geofence check ──────────────────────────────────────────────
    // Handles: GEDUNG B (radius=34 m) and any future radius-type locations.
    for (final circle in officeCircles) {
      final centerDist = Geolocator.distanceBetween(
        smoothedPos.latitude,
        smoothedPos.longitude,
        circle.point.latitude,
        circle.point.longitude,
      );

      // Use boundary distance (0 if inside, positive if outside) so the
      // distanceFromOffice display is meaningful rather than showing center dist.
      final boundaryDist =
          (centerDist - circle.radius).clamp(0.0, double.infinity);
      if (boundaryDist < nearestDistance) nearestDistance = boundaryDist;

      if (centerDist <= circle.radius + tolerance) {
        valid = true;
        AppUtils.logApp(
            'Inside circle (center=${centerDist.toStringAsFixed(1)} m, boundary=${boundaryDist.toStringAsFixed(1)} m)');
      }
    }

    // ── Polygon geofence check ─────────────────────────────────────────────
    // Handles: production GEDUNG A+B (single combined polygon), dev GEDUNG A,
    // and any future polygon-type locations.
    //
    // NOTE: runs for ALL polygons regardless of whether a circle already
    // matched, so that nearestDistance (→ distanceFromOffice) is always
    // accurate in polygon-only environments (current production response).
    for (final poly in officePolygons) {
      if (isPointInsidePolygon(smoothedPos, poly.points)) {
        // Clearly inside — distance to office is 0.
        nearestDistance = min(nearestDistance, 0.0);
        valid = true;
        AppUtils.logApp('Inside polygon (exact hit)');
        continue; // continue to capture nearestDistance for remaining polygons
      }

      // Distance to nearest polygon edge (approximation via edge midpoints).
      final boundaryDist =
          _distanceToPolygonBoundary(smoothedPos, poly.points);
      if (boundaryDist < nearestDistance) nearestDistance = boundaryDist;

      // Within indoor tolerance of the boundary → consider inside.
      if (boundaryDist <= tolerance) {
        valid = true;
        AppUtils.logApp(
            'Inside polygon (boundary tol=${tolerance.toStringAsFixed(1)} m, dist=${boundaryDist.toStringAsFixed(1)} m)');
      }
    }

    // Set AFTER all geofences evaluated so it reflects the minimum boundary
    // distance across all circles + polygons.
    distanceFromOffice.value =
        nearestDistance == double.infinity ? 0.0 : nearestDistance;

    // ── 5. Streak debouncing ──────────────────────────────────────────────
    // Prevents a single bad fix from instantly locking the user out or
    // a single good fix from prematurely enabling check-in.
    if (valid) {
      _validStreak++;
      _invalidStreak = 0;
      if (_validStreak >= _kValidStreakRequired) {
        isLocationValid.value = true;
      }
    } else {
      _invalidStreak++;
      _validStreak = 0;
      if (_invalidStreak >= _kInvalidStreakRequired) {
        isLocationValid.value = false;
      }
    }

    buttonEnabled.value = isLocationValid.value && !isGpsSpoofing.value;

    _updateOfficeColors();
    _calculateNearestOffice(smoothedPos);
  }

  /// Computes a weighted centroid from [_positionBuffer].
  /// More recent fixes and higher-accuracy fixes receive greater weight.
  LatLng _computeWeightedPosition() {
    if (_positionBuffer.isEmpty) {
      return currentPosition.value ?? const LatLng(0, 0);
    }

    double totalWeight = 0;
    double weightedLat = 0;
    double weightedLng = 0;

    for (int i = 0; i < _positionBuffer.length; i++) {
      final pos = _positionBuffer[i];

      // Recency weight: index 0 (oldest) = 1×, last = bufferSize×
      final recencyWeight = (i + 1).toDouble();

      // Accuracy weight: better accuracy (lower value) gets higher weight.
      // Guard against zero-accuracy edge case.
      final accuracyWeight = pos.accuracy > 0 ? (1.0 / pos.accuracy) : 1.0;

      final weight = recencyWeight * accuracyWeight;
      weightedLat += pos.latitude * weight;
      weightedLng += pos.longitude * weight;
      totalWeight += weight;
    }

    return LatLng(weightedLat / totalWeight, weightedLng / totalWeight);
  }

  /// Returns true if [point] is within [toleranceMeters] of any vertex or
  /// edge midpoint of [polygon]. Used to handle GPS drift at building edges
  /// (e.g. users standing near the boundary on an upper floor).
  bool _isWithinPolygonTolerance(
      LatLng point, List<LatLng> polygon, double toleranceMeters) {
    for (int i = 0; i < polygon.length; i++) {
      final vertex = polygon[i];
      final next = polygon[(i + 1) % polygon.length];

      // Distance to vertex
      final distVertex = Geolocator.distanceBetween(
        point.latitude,
        point.longitude,
        vertex.latitude,
        vertex.longitude,
      );
      if (distVertex <= toleranceMeters) return true;

      // Distance to edge midpoint (covers the middle of each side)
      final midLat = (vertex.latitude + next.latitude) / 2;
      final midLng = (vertex.longitude + next.longitude) / 2;
      final distMid = Geolocator.distanceBetween(
        point.latitude,
        point.longitude,
        midLat,
        midLng,
      );
      if (distMid <= toleranceMeters) return true;
    }
    return false;
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

    AppDialogImpl().showChoiceDialog(
        title: 'Konfirmasi',
        description: 'Mohon persiapkan diri untuk mengambil foto',
        onPressedYes: () async {
          Get.back();
          final result = await Get.toNamed(
            Routes.VALIDATION_SELFIE,
            arguments: [
              status,
              attendanceTodayRes.value,
              currentPosition.value,
              nearestOffice.value,
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
        });
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
    AppDialogImpl().showChoiceDialog(
        title: 'Konfirmasi',
        description: 'Anda yakin akan memulai sesi istirahat',
        onPressedYes: () async {
          Get.back();
          if (hasTakenBreak.value) return;

          breakTime.value = DateTime.now();
          breakDuration.value = '';
          isLoadingAttendance.value = true;

          final entity = AttendanceRecordEntity(
            id: attendanceTodayRes.value.attendanceId!,
            locationID: _getNearestLocationId(),
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
        });
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
    AppDialogImpl().showChoiceDialog(
        title: 'Konfirmasi',
        description: 'Anda yakin akan mengakhiri sesi istirahat',
        onPressedYes: () async {
          Get.back();

          breakTimer?.cancel();

          isLoadingAttendance.value = true;

          final entity = AttendanceRecordEntity(
            id: attendanceTodayRes.value.attendanceId!,
            locationID: _getNearestLocationId(),
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
            },
          );

          isLoadingAttendance.value = false;
        });
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
            locationId: loc.locationID,
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
            locationId: loc.locationID,
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

  int _getNearestLocationId() {
    final nearest = nearestOffice.value;

    return nearest!.locationId;
  }
}
