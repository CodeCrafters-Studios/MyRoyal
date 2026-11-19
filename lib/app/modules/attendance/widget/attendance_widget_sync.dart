import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';

/// Geographic bounds of the stored map image (camera bearing/tilt 0).
class WidgetMapBounds {
  const WidgetMapBounds({
    required this.north,
    required this.south,
    required this.east,
    required this.west,
  });

  final double north;
  final double south;
  final double east;
  final double west;
}

/// Position of [lat]/[lng] on the map image as fractions (0..1 from the
/// top-left), using Web Mercator like Google Maps. Null when outside the
/// image or the bounds are degenerate.
({double x, double y})? projectToMapImage(
    double lat, double lng, WidgetMapBounds b) {
  double mercY(double latDeg) =>
      math.log(math.tan(math.pi / 4 + latDeg * math.pi / 360));

  final width = b.east - b.west;
  final height = mercY(b.north) - mercY(b.south);
  if (width <= 0 || height <= 0) return null;

  final x = (lng - b.west) / width;
  final y = (mercY(b.north) - mercY(lat)) / height;
  if (x < 0 || x > 1 || y < 0 || y > 1) return null;
  return (x: x, y: y);
}

/// Display-only snapshot of the backend-confirmed attendance state for the
/// native home screen widgets (EPIC 02, design §4).
///
/// Never contains the auth token, the employee's identity or GPS coordinates.
/// The user's position is only published as a dot position on the map image
/// (fractions), plus the app's own inside/outside geofence result.
class AttendanceWidgetPayload {
  const AttendanceWidgetPayload({
    required this.signedIn,
    this.status = 'not_started',
    this.date = '',
    this.checkIn = '',
    this.checkOut = '',
    this.breakStart = '',
    this.breakEnd = '',
    this.workedMinutesAtSync = 0,
    this.breakEndsAtEpochMs = 0,
    this.breakStartedAtEpochMs = 0,
    this.serverNowAtSyncEpochMs = 0,
    this.syncedAtEpochMs = 0,
    this.officeName = '',
    this.mapDotX = -1,
    this.mapDotY = -1,
    this.locationAtEpochMs = 0,
    this.insideArea = -1,
  });

  /// Shown after logout or session expiry.
  const AttendanceWidgetPayload.signedOut() : this(signedIn: false);

  static const schema = 1;

  final bool signedIn;
  final String status;
  final String date;
  final String checkIn;
  final String checkOut;
  final String breakStart;
  final String breakEnd;
  final int workedMinutesAtSync;
  final int breakEndsAtEpochMs;

  /// Break start on the server clock, for the widget's count-up break timer
  /// (a count-down cannot stop at zero on Android widgets).
  final int breakStartedAtEpochMs;
  final int serverNowAtSyncEpochMs;
  final int syncedAtEpochMs;
  final String officeName;

  /// Dot on the map image (0..1), or -1 when unknown / off the image.
  final double mapDotX;
  final double mapDotY;

  /// Device time of the GPS fix behind the dot / [insideArea]; 0 = none.
  final int locationAtEpochMs;

  /// The app's geofence result for that fix: 1 inside, 0 outside, -1 unknown.
  /// Display only; actions are always re-validated in the app.
  final int insideArea;

  static String hhmm(DateTime? t) =>
      t == null ? '' : DateFormat('HH:mm').format(t);

  static String ymd(DateTime? d) =>
      d == null ? '' : DateFormat('yyyy-MM-dd').format(d);

  Map<String, Object> toJson() => {
        'schema': schema,
        'signedIn': signedIn,
        'status': status,
        'date': date,
        'checkIn': checkIn,
        'checkOut': checkOut,
        'breakStart': breakStart,
        'breakEnd': breakEnd,
        'workedMinutesAtSync': workedMinutesAtSync < 0 ? 0 : workedMinutesAtSync,
        'breakEndsAtEpochMs': breakEndsAtEpochMs,
        'breakStartedAtEpochMs': breakStartedAtEpochMs,
        'serverNowAtSyncEpochMs': serverNowAtSyncEpochMs,
        'syncedAtEpochMs': syncedAtEpochMs,
        'officeName': officeName,
        'mapDotX': mapDotX,
        'mapDotY': mapDotY,
        'locationAtEpochMs': locationAtEpochMs,
        'insideArea': insideArea,
      };
}

/// Storage seam over `home_widget` so the sync logic is testable.
abstract class AttendanceWidgetStore {
  Future<void> saveString(String key, String? value);
  Future<void> saveFile(String key, Uint8List bytes, String extension);
  Future<void> refreshWidgets();
}

class HomeWidgetAttendanceStore implements AttendanceWidgetStore {
  @override
  Future<void> saveString(String key, String? value) =>
      HomeWidget.saveWidgetData<String>(key, value);

  @override
  Future<void> saveFile(String key, Uint8List bytes, String extension) =>
      HomeWidget.saveFile(key, bytes, extension: extension);

  @override
  Future<void> refreshWidgets() async {
    await HomeWidget.updateWidget(
      iOSName: AttendanceWidgetSync.iosKind,
      qualifiedAndroidName: AttendanceWidgetSync.androidReceiver,
    );
  }
}

/// Single writer of widget data. Called only with backend-confirmed state
/// (from `AttendanceController._applyAttendanceToday`) and on sign-out, so
/// the widget never shows an unconfirmed transaction.
///
/// All failures are swallowed and logged: the widget is auxiliary and must
/// never break the attendance flow (e.g. before the native widget exists,
/// or on iOS before the App Group is provisioned).
class AttendanceWidgetSync {
  AttendanceWidgetSync({AttendanceWidgetStore? store})
      : _store = store ?? HomeWidgetAttendanceStore();

  /// Process-wide instance; tests replace it with a fake store.
  static AttendanceWidgetSync instance = AttendanceWidgetSync();

  static const appGroupId = 'group.com.myroyal';
  static const dataKey = 'attendance_widget_v1';
  static const mapKey = 'attendance_widget_map';
  static const iosKind = 'AttendanceWidget';
  static const androidReceiver = 'com.myroyal.widget.AttendanceWidgetReceiver';

  final AttendanceWidgetStore _store;
  DateTime? _lastMapSnapshotDay;
  WidgetMapBounds? _mapBounds;

  /// Bounds of the map image saved by this process (null until then, so no
  /// dot is published against an image of unknown bounds).
  WidgetMapBounds? get mapBounds => _mapBounds;

  /// Call once at startup (iOS needs the App Group for shared storage).
  static Future<void> configure() async {
    try {
      await HomeWidget.setAppGroupId(appGroupId);
    } catch (e) {
      AppUtils.logApp('WIDGET ::: setAppGroupId failed: $e');
    }
  }

  Future<void> save(AttendanceWidgetPayload payload) async {
    try {
      await _store.saveString(dataKey, jsonEncode(payload.toJson()));
      await _store.refreshWidgets();
    } catch (e) {
      AppUtils.logApp('WIDGET ::: save failed: $e');
    }
  }

  /// Logout, session expiry or account switch.
  Future<void> clear() async {
    _lastMapSnapshotDay = null;
    _mapBounds = null;
    try {
      await _store.saveString(mapKey, null);
      await _store.saveString(
          dataKey, jsonEncode(const AttendanceWidgetPayload.signedOut().toJson()));
      await _store.refreshWidgets();
    } catch (e) {
      AppUtils.logApp('WIDGET ::: clear failed: $e');
    }
  }

  /// At most one map image per calendar day ([day] from the server clock).
  bool needsMapSnapshot(DateTime day) {
    final last = _lastMapSnapshotDay;
    return last == null ||
        last.year != day.year ||
        last.month != day.month ||
        last.day != day.day;
  }

  Future<void> saveMapSnapshot(
    Uint8List jpeg,
    DateTime day,
    WidgetMapBounds bounds,
  ) async {
    try {
      await _store.saveFile(mapKey, jpeg, 'jpg');
      _lastMapSnapshotDay = day;
      _mapBounds = bounds;
      await _store.refreshWidgets();
    } catch (e) {
      AppUtils.logApp('WIDGET ::: map snapshot failed: $e');
    }
  }
}
