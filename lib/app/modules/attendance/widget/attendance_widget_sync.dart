import 'dart:convert';
import 'dart:typed_data';

import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';

/// Display-only snapshot of the backend-confirmed attendance state for the
/// native home screen widgets (EPIC 02, design §4).
///
/// Never contains the auth token, the employee's identity or GPS coordinates.
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
    this.serverNowAtSyncEpochMs = 0,
    this.syncedAtEpochMs = 0,
    this.officeName = '',
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
  final int serverNowAtSyncEpochMs;
  final int syncedAtEpochMs;
  final String officeName;

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
        'serverNowAtSyncEpochMs': serverNowAtSyncEpochMs,
        'syncedAtEpochMs': syncedAtEpochMs,
        'officeName': officeName,
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

  Future<void> saveMapSnapshot(Uint8List jpeg, DateTime day) async {
    try {
      await _store.saveFile(mapKey, jpeg, 'jpg');
      _lastMapSnapshotDay = day;
      await _store.refreshWidgets();
    } catch (e) {
      AppUtils.logApp('WIDGET ::: map snapshot failed: $e');
    }
  }
}
