import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:intl/intl.dart';
import 'package:MyRoyal/app/modules/attendance/data/models/attendance_location_model.dart';
import 'package:MyRoyal/app/modules/attendance/data/models/attendance_today_model.dart';
import 'package:MyRoyal/app/modules/attendance/domain/entities/attendance_record_entity.dart';
import 'package:MyRoyal/app/modules/attendance/domain/entities/neares_office_info_entity.dart';
import 'package:MyRoyal/app/modules/attendance/domain/usecases/get_attendance_location_usecase.dart';
import 'package:MyRoyal/app/modules/attendance/domain/usecases/get_attendance_today_usecase.dart';
import 'package:MyRoyal/app/modules/attendance/domain/usecases/record_attendance_usecase.dart';
import 'package:MyRoyal/app/modules/attendance/utils/attendance_time.dart';
import 'package:MyRoyal/app/routes/app_pages.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/services/http_service.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';

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
    RxString? connectionStatus,
  }) : _connectionStatusOverride = connectionStatus;

  /// Test seam; defaults to [HttpService.connectionStatus].
  final RxString? _connectionStatusOverride;
  RxString get _connectionStatus =>
      _connectionStatusOverride ?? Get.find<HttpService>().connectionStatus;

  final currentTime = DateTime.now().obs;
  final checkInTime = Rxn<DateTime>();
  final checkOutTime = Rxn<DateTime>();
  final breakTime = Rxn<DateTime>();
  final breakEndTime = Rxn<DateTime>();
  final breakDuration = ''.obs;
  final hasTakenBreak = false.obs;
  final isLoadingAttendance = true.obs;
  final isMapReady = false.obs;
  final displayTime = DateTime.now().obs;
  final endDayMessage = ''.obs;

  RxList<AttendanceLocationModel> officeLocations =
      <AttendanceLocationModel>[].obs;
  RxList<Circle> officeCircles = <Circle>[].obs;
  RxList<Marker> officeMarkers = <Marker>[].obs;
  RxList<Polygon> officePolygons = <Polygon>[].obs;

  final currentPosition = Rxn<LatLng>();
  GoogleMapController? googleMapController;
  final isGmsAvailable = true.obs;
  void Function(double latitude, double longitude, double zoom)? onMoveMap;

  final isGpsActive = false.obs;
  final isMockLocation = false.obs;
  final isGpsSpoofing = false.obs;
  final isMapInteracting = false.obs;
  final isLocationValid = false.obs;
  final gpsAccuracy = 0.0.obs;
  final distanceFromOffice = 0.0.obs;
  final nearestOffice = Rxn<NearestOfficeInfo>();
  LatLng? _smoothedPosition;
  final isPerformingAction = false.obs;

  /// True while a silent (background) refresh of today's attendance runs.
  /// Unlike [isLoadingAttendance] it does not swap the screen for a shimmer.
  final isRefreshingAttendance = false.obs;

  /// Value emitted by [HttpService.connectionStatus] when offline.
  static const _offlineStatus = 'Tidak ada koneksi';

  bool get isOffline => _connectionStatus.value == _offlineStatus;

  final _hasAttendanceData = false.obs;

  /// Whether today's attendance was fetched successfully at least once.
  /// Until then the screen shows the initial placeholder (or an error).
  bool get hasAttendanceData => _hasAttendanceData.value;

  /// Set when the first load failed and there is nothing to show yet.
  final hasLoadError = false.obs;

  /// Whether action buttons look enabled. A background refresh does not
  /// disable them (no flicker); actions wait for it instead, see
  /// [_ensureActionAllowed].
  bool get areActionsReady =>
      !isLoadingAttendance.value &&
      !isPerformingAction.value &&
      !isOffline &&
      isMapReady.value &&
      currentPosition.value != null;

  StreamSubscription<Position>? _positionStream;
  Timer? _mapMoveDebounce;

  final buttonEnabled = false.obs;
  final attendanceStatus = AttendanceStatus.notStarted.obs;
  bool _isInitialized = false;

  Rx<AttendanceTodayModel> attendanceTodayRes =
      AttendanceTodayModel.empty().obs;

  Timer? _timer;
  Timer? breakTimer;
  int _breakDurationSeconds = 0;

  RxString totalHours = '--:--'.obs;
  final liveWorkDuration = '--:--'.obs;
  DateTime? _serverTime;
  DateTime? _breakStartTime;
  DateTime? _deviceTimeAtSync;
  DateTime? _lastDisplayTime;

  /// Device time of the last `today` request, successful or not.
  DateTime? _lastFetchAttemptAt;

  /// Incremented per `today` request; only the newest response is applied.
  int _fetchSeq = 0;
  bool _isFetchingToday = false;
  Future<void>? _todayFetch;

  /// Bounded retries while the backend still returns a previous-day record
  /// (midnight cron may run a few minutes after 00:00).
  int _staleDayRetries = 0;
  static const _maxStaleDayRetries = 3;
  static const _staleDayRetryInterval = Duration(minutes: 2);
  static const _resumeRefreshThrottle = Duration(seconds: 30);
  RxString countTimes = '--:--:--'.obs;
  final workDurationMinutes = 0.obs;
  final isBreakTimerDone = false.obs;

  final GetAttendanceTodayUsecase getAttendanceTodayUsecase;
  final RecordAttendanceUsecase recordAttendanceUsecase;
  final GetAttendanceLocationUsecase getAttendanceLocationUsecase;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _checkGmsAvailability();

    ever(_connectionStatus, (String status) {
      if (status == _offlineStatus) return; // keep last known state visible

      if (!_isInitialized) {
        _runInitialOnce();
      } else {
        _refreshTodaySilently(); // reconnected: resync with backend
      }
    });

    ever(isMapReady, (bool ready) {
      final pending = _pendingBounds;
      if (ready && pending != null) _fitMapBounds(pending);
    });

    _runInitialOnce();
  }

  List<LatLng>? _pendingBounds;

  Future<void> _checkGmsAvailability() async {
    if (GetPlatform.isAndroid) {
      try {
        final availability = await GoogleApiAvailability.instance
            .checkGooglePlayServicesAvailability();
        isGmsAvailable.value =
            availability == GooglePlayServicesAvailability.success;
      } catch (e) {
        isGmsAvailable.value = false;
        AppUtils.logApp("Failed to check GMS availability: $e");
      }
    } else {
      isGmsAvailable.value = true;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_isInitialized) return;

    if (state == AppLifecycleState.paused) {
      // Nothing is visible: stop the 1 s clock and the 1 Hz GPS stream.
      _timer?.cancel();
      breakTimer?.cancel();
      _positionStream?.cancel();
      _positionStream = null;
      return;
    }

    if (state != AppLifecycleState.resumed) return;

    final last = _lastFetchAttemptAt;
    final recentlyFetched = last != null &&
        DateTime.now().difference(last) < _resumeRefreshThrottle;

    // Always resync after a date boundary; otherwise throttle.
    if (!recentlyFetched || _isPreviousDayRecord()) {
      _refreshTodaySilently();
    }

    _startTimer();
    if (attendanceStatus.value == AttendanceStatus.breakStart) {
      _scheduleBreakCountdownStart();
    }
    if (attendanceStatus.value != AttendanceStatus.checkedOut) {
      _initLocation();
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _mapMoveDebounce?.cancel();
    _timer?.cancel();
    breakTimer?.cancel();
    _positionStream?.cancel();
    super.onClose();
  }

  void _runInitialOnce() {
    if (_isInitialized) return;
    if (isOffline) return;

    _isInitialized = true;
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Day-specific fields are reset from each `today` response in
    // [_applyAttendanceToday]. Office locations are loaded once and retried
    // on refresh if the previous attempt failed.
    if (officeLocations.isEmpty) {
      _getAttendanceLocation();
    }

    await _getAttendanceToday();
    _startTimer();
    if (attendanceStatus.value != AttendanceStatus.checkedOut) {
      await _initLocation();
    }
  }

  /// Background resync that keeps the current UI (no full-screen shimmer).
  /// Skipped when a fetch is already running or the device is offline.
  Future<void> _refreshTodaySilently() async {
    if (_isFetchingToday || isOffline) return;
    await _getAttendanceToday(silent: true);
  }

  /// True when the loaded record belongs to an earlier date than the server
  /// clock, i.e. the midnight reset has not been reflected yet.
  bool _isPreviousDayRecord() {
    final recordDate = attendanceTodayRes.value.date;
    if (recordDate == null ||
        attendanceStatus.value == AttendanceStatus.notStarted) {
      return false;
    }
    return dateOnly(recordDate).isBefore(dateOnly(_currentServerTime()));
  }

  DateTime _currentServerTime() {
    final now = DateTime.now();
    if (_serverTime == null || _deviceTimeAtSync == null) return now;
    return _serverTime!.add(now.difference(_deviceTimeAtSync!));
  }

  /// Called every timer tick: refetch (bounded) once the server clock has
  /// passed midnight while a previous-day record is still shown.
  void _maybeRefreshAfterDateBoundary() {
    if (_staleDayRetries >= _maxStaleDayRetries || !_isPreviousDayRecord()) {
      return;
    }
    final last = _lastFetchAttemptAt;
    if (last != null &&
        DateTime.now().difference(last) < _staleDayRetryInterval) {
      return;
    }
    _staleDayRetries++;
    _refreshTodaySilently();
  }

  /// Pull-to-refresh. Keeps the current content on screen while loading.
  Future<void> onRefresh() async {
    await _loadInitialData();
    if (isMapReady.value) {
      _fitMapBounds(officeCircles.map((c) => c.center).toList() +
          officePolygons.expand((p) => p.points).toList());
    }
  }

  Future<void> _getAttendanceLocation() async {
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
      officePolygons.clear();

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
            Circle(
              circleId: CircleId(loc.locationID.toString()),
              center: markerPoint,
              radius: loc.stkamurd.radius * 1.0,
              fillColor: isLocationValid.value
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              strokeColor: isLocationValid.value ? Colors.green : Colors.red,
              strokeWidth: 2,
            ),
          );

          boundPoints.add(markerPoint);
        }

        if (loc.typeArea == "polygon") {
          final polygonPoints =
              loc.polygon.map((e) => LatLng(e[0], e[1])).toList();

          officePolygons.add(
            Polygon(
              polygonId: PolygonId(loc.locationID.toString()),
              points: polygonPoints,
              fillColor: isLocationValid.value
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              strokeColor: isLocationValid.value ? Colors.green : Colors.red,
              strokeWidth: 2,
            ),
          );

          boundPoints.addAll(polygonPoints);
          markerPoint = polygonPoints.first;
        }

        if (markerPoint != null) {
          officeMarkers.add(
            Marker(
              markerId: MarkerId(loc.locationID.toString()),
              position: markerPoint,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
            ),
          );
        }
      }

      _fitMapBounds(boundPoints);
      _updateOfficeColors();
    });
  }

  void _fitMapBounds(List<LatLng> points) {
    if (!isGmsAvailable.value) {
      if (points.isEmpty) return;
      final centerLat =
          points.map((p) => p.latitude).reduce((a, b) => a + b) / points.length;
      final centerLng = points.map((p) => p.longitude).reduce((a, b) => a + b) /
          points.length;
      onMoveMap?.call(centerLat, centerLng, 18.0);
      return;
    }

    if (!isMapReady.value || googleMapController == null) {
      // Applied once the map reports ready (see onInit). Previously this
      // re-scheduled itself every 200 ms forever when no map was built,
      // e.g. in the checked-out layout.
      _pendingBounds = points;
      return;
    }
    _pendingBounds = null;

    if (points.isEmpty) return;

    double x0 = points[0].latitude;
    double x1 = points[0].latitude;
    double y0 = points[0].longitude;
    double y1 = points[0].longitude;

    for (LatLng latLng in points) {
      if (latLng.latitude > x1) x1 = latLng.latitude;
      if (latLng.latitude < x0) x0 = latLng.latitude;
      if (latLng.longitude > y1) y1 = latLng.longitude;
      if (latLng.longitude < y0) y0 = latLng.longitude;
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(x0, y0),
      northeast: LatLng(x1, y1),
    );

    googleMapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 18),
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

  /// Fetches today's attendance from the backend (the source of truth).
  ///
  /// Full-screen loading is only used while nothing has been loaded yet;
  /// afterwards the current content stays visible ([isRefreshingAttendance]).
  /// [silent] suppresses the error snackbar for background refreshes.
  Future<void> _getAttendanceToday({bool silent = false}) {
    final future = _fetchToday(silent: silent);
    _todayFetch = future;
    return future;
  }

  Future<void> _fetchToday({required bool silent}) async {
    final seq = ++_fetchSeq;
    _isFetchingToday = true;
    _lastFetchAttemptAt = DateTime.now();
    if (hasAttendanceData) {
      isRefreshingAttendance.value = true;
    } else {
      isLoadingAttendance.value = true;
      hasLoadError.value = false;
    }

    final result = await getAttendanceTodayUsecase();

    // Ignore responses superseded by a newer request (e.g. a background
    // refresh racing a post-action refetch).
    if (seq != _fetchSeq) return;

    result.fold(
      (l) {
        AppUtils.logApp('GET ATTENDANCE TODAY FAILED ::: ${l.properties}');
        if (!hasAttendanceData) hasLoadError.value = true;
        if (!silent && !isOffline) {
          AppDialogImpl().showErrorSnackBar(
            description: 'Gagal memuat data kehadiran. Silakan coba lagi.',
          );
        }
      },
      _applyAttendanceToday,
    );

    _isFetchingToday = false;
    _todayFetch = null;
    isRefreshingAttendance.value = false;
    isLoadingAttendance.value = false;
  }

  /// Derives every day-specific field from [r]. Values are always overwritten
  /// (also with null) so a previous day's times never survive the midnight
  /// reset. Wall-clock values are anchored to the backend attendance `date`.
  void _applyAttendanceToday(AttendanceTodayModel r) {
    _hasAttendanceData.value = true;
    hasLoadError.value = false;
    attendanceTodayRes.value = r;
    attendanceStatus.value = AttendanceStatusX.fromString(r.status);

    final baseDate = dateOnly(r.date ?? DateTime.now());
    final checkIn = parseServerClock(r.checkedInTime, baseDate);
    final breakStart =
        parseServerClock(r.breakStartTime, baseDate, notBefore: checkIn);
    final breakEnd =
        parseServerClock(r.breakEndTime, baseDate, notBefore: checkIn);
    final checkOut =
        parseServerClock(r.checkedOutTime, baseDate, notBefore: checkIn);

    checkInTime.value = checkIn;
    breakTime.value = breakStart;
    breakEndTime.value = breakEnd;
    checkOutTime.value = checkOut;
    hasTakenBreak.value = breakStart != null;

    _syncServerClock(r.serverTime, baseDate, notBefore: checkIn);

    // Break countdown only runs while on break.
    breakTimer?.cancel();
    if (attendanceStatus.value == AttendanceStatus.breakStart &&
        breakStart != null) {
      _breakStartTime = breakStart;
      _breakDurationSeconds = (r.durationBreak ?? 0) * 60;
      _scheduleBreakCountdownStart();
    } else {
      _breakStartTime = null;
      countTimes.value = '--:--:--';
      isBreakTimerDone.value = false;
    }

    breakDuration.value = (breakStart != null && breakEnd != null)
        ? formatHoursMinutes(breakEnd.difference(breakStart))
        : '';

    if (checkIn != null && checkOut != null) {
      _totalHours();
      liveWorkDuration.value = totalHours.value;
    } else {
      totalHours.value = '--:--';
    }

    if (attendanceStatus.value == AttendanceStatus.notStarted) {
      liveWorkDuration.value = '--:--';
      workDurationMinutes.value = 0;
    }

    if (attendanceStatus.value == AttendanceStatus.checkedOut) {
      if (endDayMessage.value.isEmpty) {
        endDayMessage.value = (endDayMessages..shuffle()).first;
      }
    } else {
      endDayMessage.value = '';
    }

    if (!_isPreviousDayRecord()) _staleDayRetries = 0;
  }

  /// Re-anchors the ticking clock to the backend `server_time`.
  void _syncServerClock(
    String? serverTime,
    DateTime baseDate, {
    DateTime? notBefore,
  }) {
    final now = DateTime.now();
    _serverTime =
        parseServerClock(serverTime, baseDate, notBefore: notBefore) ?? now;
    _deviceTimeAtSync = now;
    // Let the displayed clock follow a resync even if it moves backwards.
    _lastDisplayTime = _serverTime;
    displayTime.value = _serverTime!;
  }

  Future<void> _initLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    isGpsActive.value = serviceEnabled;

    if (!serviceEnabled) {
      _invalidateLocation();
      _showEnableGpsDialog();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      _invalidateLocation();
      _showPermissionDialog();
      return;
    }

    if (permission == LocationPermission.deniedForever) {
      _invalidateLocation();
      _showPermissionSettingsDialog();
      return;
    }

    _startLocationStream();
  }

  /// GPS off or permission missing: stop the stream and mark the last known
  /// position as unusable so it cannot be used for an attendance action.
  void _invalidateLocation() {
    _positionStream?.cancel();
    _positionStream = null;
    isGpsActive.value = false;
    if (isLocationValid.value) {
      isLocationValid.value = false;
      _updateOfficeColors();
    }
    buttonEnabled.value = false;
  }

  /// Resume and refresh both call [_initLocation]; never stack dialogs.
  bool get _isDialogOpen => Get.isDialogOpen ?? false;

  void _showEnableGpsDialog() {
    if (_isDialogOpen) return;
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
    if (_isDialogOpen) return;
    Get.defaultDialog(
      title: "Izin Lokasi Dibutuhkan",
      middleText: "Aplikasi membutuhkan akses lokasi.",
      textConfirm: "Izinkan",
      onConfirm: () async {
        Get.back();
        await Geolocator.requestPermission();
        await _initLocation();
      },
    );
  }

  void _showPermissionSettingsDialog() {
    if (_isDialogOpen) return;
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
    if (isClosed) return;
    AndroidSettings locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 1,
      intervalDuration: Duration(seconds: 1),
    );

    // Every fetch/resume calls this; never stack a second subscription.
    _positionStream?.cancel();
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

    if (newPosition.accuracy > 25) {
      return;
    }

    final rawPosition = LatLng(
      newPosition.latitude,
      newPosition.longitude,
    );

    final smoothed = _smoothPosition(rawPosition);

    if (currentPosition.value != null) {
      final movement = Geolocator.distanceBetween(
        currentPosition.value!.latitude,
        currentPosition.value!.longitude,
        smoothed.latitude,
        smoothed.longitude,
      );

      if (movement < 0.8) {
        return;
      }
    }

    currentPosition.value = smoothed;

    _moveMapRealtime(smoothed);

    bool valid = false;
    double nearestDistance = double.infinity;

    /// CHECK RADIUS
    for (final circle in officeCircles) {
      final meter = Geolocator.distanceBetween(
        smoothed.latitude,
        smoothed.longitude,
        circle.center.latitude,
        circle.center.longitude,
      );

      if (meter < nearestDistance) {
        nearestDistance = meter;
      }

      final tolerance = max(
        min(gpsAccuracy.value, 8),
        3,
      );

      if (meter <= circle.radius + tolerance) {
        valid = true;
      }
    }

    /// CHECK POLYGON
    if (!valid) {
      for (final poly in officePolygons) {
        if (isPointInsidePolygon(smoothed, poly.points)) {
          valid = true;
          break;
        }
      }
    }

    final oldValue = isLocationValid.value;

    isLocationValid.value = valid;

    /// ONLY redraw if changed
    if (oldValue != valid) {
      _updateOfficeColors();
    }

    buttonEnabled.value = isLocationValid.value && !isGpsSpoofing.value;

    distanceFromOffice.value = nearestDistance;

    _calculateNearestOffice(smoothed);
  }

  void _startTimer() {
    // Async callers may resume after the controller was closed (logout).
    if (isClosed || (_timer?.isActive ?? false)) return;

    // The clock is (re)anchored on every successful fetch in
    // [_syncServerClock]; fall back to the device clock until then.
    if (_serverTime == null || _deviceTimeAtSync == null) {
      final now = DateTime.now();
      _serverTime = now;
      _deviceTimeAtSync = now;
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _maybeRefreshAfterDateBoundary();
      // Completed day: the clock and live duration are not shown; skip the
      // per-second rebuilds.
      if (attendanceStatus.value == AttendanceStatus.checkedOut) return;

      final currentTime = _getMonotonicDisplayTime(_currentServerTime());
      displayTime.value = currentTime;
      _updateLiveDuration(currentTime);
    });
  }

  DateTime _getMonotonicDisplayTime(DateTime candidateTime) {
    final lastTime = _lastDisplayTime ?? displayTime.value;

    if (candidateTime.isBefore(lastTime)) {
      return lastTime;
    }

    _lastDisplayTime = candidateTime;
    return candidateTime;
  }

  void _updateLiveDuration(DateTime currentServerTime) {
    if (attendanceStatus.value == AttendanceStatus.notStarted) {
      liveWorkDuration.value = '--:--';
      return;
    }
    if (attendanceStatus.value == AttendanceStatus.checkedOut) {
      liveWorkDuration.value = totalHours.value;
      return;
    }

    final checkIn = checkInTime.value;
    if (checkIn == null) {
      liveWorkDuration.value = '--:--';
      return;
    }

    final worked = computeWorkDuration(
      checkIn: checkIn,
      end: currentServerTime,
      breakStart: breakTime.value,
      breakEnd: breakEndTime.value,
      onBreak: attendanceStatus.value == AttendanceStatus.breakStart,
    );

    workDurationMinutes.value = worked.inMinutes;
    liveWorkDuration.value = formatHoursMinutes(worked);
  }

  /// Statuses from which each backend action is valid (mirrors the buttons
  /// shown by the view for each state).
  static const Map<String, Set<AttendanceStatus>> _allowedFrom = {
    'checked_in': {AttendanceStatus.notStarted},
    'break_start': {AttendanceStatus.checkedIn},
    'break_end': {AttendanceStatus.breakStart},
    'checked_out': {AttendanceStatus.checkedIn, AttendanceStatus.breakEnd},
  };

  /// Prevents duplicate submissions from repeated taps.
  bool _actionInProgress = false;

  /// Waits for a running refresh, then checks that [action] is still valid
  /// for the latest backend state and that location data is usable.
  Future<bool> _ensureActionAllowed(String action) async {
    final pending = _todayFetch;
    if (pending != null) await pending;

    if (!areActionsReady) return false;

    if (!(_allowedFrom[action]?.contains(attendanceStatus.value) ?? false)) {
      AppDialogImpl().showErrorSnackBar(
          description:
              'Status kehadiran sudah berubah. Silakan periksa kembali.');
      return false;
    }
    if (!isLocationValid.value) {
      AppDialogImpl().showErrorSnackBar(
          description: "Anda harus berada di dalam radius kantor.");
      return false;
    }
    if (nearestOffice.value == null || currentPosition.value == null) {
      AppDialogImpl().showErrorSnackBar(
          description: 'Lokasi belum siap. Silakan tunggu sebentar.');
      return false;
    }
    return true;
  }

  Future<void> validationSelfie(String status) async {
    if (!areActionsReady) return;

    if (!isLocationValid.value) {
      AppDialogImpl().showErrorSnackBar(
          description: "Anda harus berada di dalam radius kantor.");
      return;
    }

    AppDialogImpl().showChoiceDialog(
        title: 'Konfirmasi',
        description: 'Mohon persiapkan diri untuk mengambil foto',
        onPressedYes: () async {
          Get.back();
          await openSelfie(status);
        });
  }

  /// Opens the selfie screen, which records check-in / check-out. The state
  /// shown afterwards always comes from a backend refetch.
  Future<void> openSelfie(String status) async {
    if (_actionInProgress) return;
    _actionInProgress = true;
    try {
      if (!await _ensureActionAllowed(status)) return;

      final serverTime = attendanceTodayRes.value.serverTime;
      if (serverTime == null || serverTime.isEmpty) {
        AppDialogImpl().showErrorSnackBar(
            description: 'Data kehadiran belum siap. Silakan muat ulang.');
        return;
      }

      isPerformingAction.value = true;
      final result = await Get.toNamed(
        Routes.VALIDATION_SELFIE,
        arguments: [
          status,
          attendanceTodayRes.value,
          currentPosition.value,
          nearestOffice.value,
          isGpsSpoofing.value,
          workDurationMinutes.value
        ],
      );

      await _getAttendanceToday();

      if (!(result == true && status == 'checked_in')) {
        isGpsSpoofing.value = false;
      }
      // GPS is only needed until the day is completed.
      if (attendanceStatus.value == AttendanceStatus.checkedOut) {
        _positionStream?.cancel();
        _positionStream = null;
      }
    } finally {
      _actionInProgress = false;
      isPerformingAction.value = false;
    }
  }

  void _totalHours() {
    breakTimer?.cancel();

    final checkIn = checkInTime.value;
    final checkOut = checkOutTime.value;

    if (checkIn == null || checkOut == null) {
      totalHours.value = '--h --m';
      workDurationMinutes.value = 0;
      return;
    }

    final worked = computeWorkDuration(
      checkIn: checkIn,
      end: checkOut,
      breakStart: breakTime.value,
      breakEnd: breakEndTime.value,
    );

    totalHours.value = formatHoursMinutes(worked);
    workDurationMinutes.value = worked.inMinutes;
  }

  void startBreakTime() async {
    if (!areActionsReady) return;

    AppDialogImpl().showChoiceDialog(
        title: 'Konfirmasi',
        description: 'Anda yakin akan memulai sesi istirahat',
        onPressedYes: () async {
          Get.back();
          await recordBreakStart();
        });
  }

  void endBreakTime() async {
    if (!areActionsReady) return;

    AppDialogImpl().showChoiceDialog(
        title: 'Konfirmasi',
        description: 'Anda yakin akan mengakhiri sesi istirahat',
        onPressedYes: () async {
          Get.back();
          await recordBreakEnd();
        });
  }

  Future<void> recordBreakStart() =>
      _recordBreak('break_start', 'Gagal record Break Start');

  Future<void> recordBreakEnd() =>
      _recordBreak('break_end', 'Gagal record Break End');

  /// Records a break transition. Nothing is applied optimistically: the UI
  /// changes only through the refetch after the POST, and a failed POST is
  /// also followed by a refetch in case the server did store it.
  Future<void> _recordBreak(String action, String failureMessage) async {
    if (_actionInProgress) return;
    _actionInProgress = true;
    try {
      if (!await _ensureActionAllowed(action)) return;
      isPerformingAction.value = true;

      final now = DateTime.now();
      final position = currentPosition.value!;
      final entity = AttendanceRecordEntity(
        id: attendanceTodayRes.value.attendanceId ?? 0,
        locationID: nearestOffice.value!.locationId,
        status: action,
        date: now,
        time: now,
        latitude: position.latitude,
        longitude: position.longitude,
        workDurationMinutes: 0,
        banned: isGpsSpoofing.value,
        file: '',
      );

      final result = await recordAttendanceUsecase(entity);
      if (result.isLeft()) {
        AppDialogImpl().showErrorSnackBar(description: failureMessage);
      }

      await _getAttendanceToday(silent: result.isLeft());
    } finally {
      _actionInProgress = false;
      isPerformingAction.value = false;
    }
  }

  void _scheduleBreakCountdownStart() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // The frame can land after onClose; never start a timer then.
      if (isClosed || attendanceStatus.value != AttendanceStatus.breakStart) {
        return;
      }

      _runBreakTimer();
    });
  }

  void _runBreakTimer() {
    breakTimer?.cancel();

    if (_breakStartTime == null) {
      return;
    }

    void updateCountdown() {
      final elapsed =
          _currentServerTime().difference(_breakStartTime!).inSeconds;
      final remaining = _breakDurationSeconds - elapsed;

      if (remaining <= 0) {
        countTimes.value = '00:00:00';
        isBreakTimerDone.value = true;
        return;
      }

      countTimes.value = _formatDuration(Duration(seconds: remaining));
      isBreakTimerDone.value = false;
    }

    updateCountdown();

    if (isBreakTimerDone.value) {
      return;
    }

    breakTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        updateCountdown();

        if (isBreakTimerDone.value) {
          breakTimer?.cancel();
        }
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
        .map((c) => Circle(
              circleId: c.circleId,
              center: c.center,
              radius: c.radius,
              fillColor: fillColor,
              strokeColor: borderColor,
              strokeWidth: 2,
            ))
        .toList();
    officeCircles.assignAll(newCircles);

    // Update semua polygon
    final newPolygons = officePolygons
        .map((p) => Polygon(
              polygonId: p.polygonId,
              points: p.points,
              fillColor: fillColor,
              strokeColor: borderColor,
              strokeWidth: 2,
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

        final center = _getPolygonCenter(polygonPoints);
        final centerDistance = Geolocator.distanceBetween(
          userPos.latitude,
          userPos.longitude,
          center.latitude,
          center.longitude,
        );

        if (boundaryDistance < nearestDistance) {
          nearestDistance = boundaryDistance;

          nearest = NearestOfficeInfo(
            locationName: loc.location,
            locationId: loc.locationID,
            type: "polygon",
            distanceToCenter: centerDistance,
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

    if (isGmsAvailable.value) {
      if (googleMapController != null) {
        googleMapController!.animateCamera(
          CameraUpdate.newLatLngZoom(pos, 18),
        );
      }
    } else {
      onMoveMap?.call(pos.latitude, pos.longitude, 18.0);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");

    return "${twoDigits(duration.inHours)}:"
        "${twoDigits(duration.inMinutes.remainder(60))}:"
        "${twoDigits(duration.inSeconds.remainder(60))}";
  }

  double _distanceToPolygonBoundary(LatLng point, List<LatLng> polygon) {
    double minDistance = double.infinity;

    for (int i = 0; i < polygon.length; i++) {
      final p1 = polygon[i];
      final p2 = polygon[(i + 1) % polygon.length];

      // Correction factor for longitude based on latitude
      final double latMid = (p1.latitude + p2.latitude) / 2.0;
      final double cosLat = cos(latMid * pi / 180.0);

      // Convert differences to equivalent flat-plane units
      final double dx = (p2.longitude - p1.longitude) * cosLat;
      final double dy = (p2.latitude - p1.latitude);

      final double px = (point.longitude - p1.longitude) * cosLat;
      final double py = (point.latitude - p1.latitude);

      final double lengthSquared = dx * dx + dy * dy;

      double t = 0.0;
      if (lengthSquared != 0.0) {
        t = (px * dx + py * dy) / lengthSquared;
        t = t.clamp(0.0, 1.0);
      }

      // Closest point on the segment
      final double closestLat = p1.latitude + t * (p2.latitude - p1.latitude);
      final double closestLng =
          p1.longitude + t * (p2.longitude - p1.longitude);

      final distance = Geolocator.distanceBetween(
        point.latitude,
        point.longitude,
        closestLat,
        closestLng,
      );

      if (distance < minDistance) {
        minDistance = distance;
      }
    }

    return minDistance;
  }

  LatLng _getPolygonCenter(List<LatLng> polygon) {
    double latSum = 0;
    double lngSum = 0;

    for (var point in polygon) {
      latSum += point.latitude;
      lngSum += point.longitude;
    }

    return LatLng(latSum / polygon.length, lngSum / polygon.length);
  }

  String get formattedDisplayTime {
    if (attendanceStatus.value == AttendanceStatus.breakStart) {
      return countTimes.value;
    } else if (attendanceStatus.value == AttendanceStatus.checkedOut) {
      return DateFormat('hh:mm:ss a')
          .format(checkOutTime.value ?? DateTime.now());
    }

    return DateFormat('hh:mm:ss a').format(displayTime.value);
  }

  String formatApiTime(String? time) {
    if (time == null || time.isEmpty) {
      return '--:--';
    }

    try {
      final parsed = DateFormat("HH:mm:ss").parse(time);
      return DateFormat('hh:mm a').format(parsed);
    } catch (_) {
      return '--:--';
    }
  }

  LatLng _smoothPosition(LatLng newPos) {
    if (_smoothedPosition == null) {
      _smoothedPosition = newPos;
      return newPos;
    }

    const alpha = 0.2;

    final lat =
        (_smoothedPosition!.latitude * (1 - alpha)) + (newPos.latitude * alpha);

    final lng = (_smoothedPosition!.longitude * (1 - alpha)) +
        (newPos.longitude * alpha);

    _smoothedPosition = LatLng(lat, lng);

    return _smoothedPosition!;
  }

  void _moveMapRealtime(LatLng pos) {
    if (isPerformingAction.value) return;

    _mapMoveDebounce?.cancel();

    _mapMoveDebounce = Timer(
      const Duration(milliseconds: 300),
      () async {
        if (isGmsAvailable.value) {
          if (isMapReady.value && googleMapController != null) {
            googleMapController!
                .animateCamera(CameraUpdate.newLatLngZoom(pos, 18));
          }
        } else {
          onMoveMap?.call(pos.latitude, pos.longitude, 18.0);
        }
      },
    );
  }

  final List<String> endDayMessages = [
    "Hari ini telah kamu lewati dengan baik. Terima kasih sudah memberikan usaha terbaikmu.",
    "Kerja kerasmu hari ini adalah langkah kecil menuju masa depan yang lebih besar.",
    "Satu hari produktif telah selesai. Saatnya beristirahat dan memulihkan energi.",
    "Terima kasih sudah bertahan dan memberikan yang terbaik hari ini.",
    "Hari ini mungkin melelahkan, tapi kamu berhasil melewatinya dengan hebat.",
    "Setiap usaha yang kamu lakukan hari ini sangat berarti.",
    "Selamat, kamu berhasil menyelesaikan hari ini dengan baik.",
    "Istirahat yang cukup, besok adalah kesempatan baru untuk berkembang.",
    "Perjalanan hari ini selesai. Nikmati waktumu untuk recharge energi.",
    "Kamu sudah melakukan yang terbaik hari ini. Good job!",
  ];

  String get randomEndDayMessage {
    endDayMessages.shuffle();
    return endDayMessages.first;
  }
}
