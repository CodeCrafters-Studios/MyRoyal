import 'dart:async';

import 'package:home_widget/home_widget.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';

/// Receives taps from the native widgets and forwards them to the existing
/// in-app attendance flow (EPIC 02 design §3, decision D1: every action opens
/// the app). It holds no attendance logic of its own.
///
/// URI contract (shared with the native widgets):
/// `myroyal://attendance?action=<check_in|break_start|break_end|check_out>`
/// `myroyal://attendance` (no/unknown action) just opens the attendance tab.
abstract class AttendanceWidgetActionTarget {
  /// Runs [action] through the normal guarded flow (confirm dialog,
  /// geofence, selfie / break POST, backend refetch).
  void handleWidgetAction(String action);
}

class AttendanceWidgetLaunchHandler {
  AttendanceWidgetLaunchHandler({
    required this.isSignedIn,
    required this.openAttendanceTab,
    Stream<Uri?>? clicks,
    Future<Uri?> Function()? initialUri,
    DateTime Function()? now,
  })  : _clicks = clicks ?? HomeWidget.widgetClicked,
        _initialUri = initialUri ?? HomeWidget.initiallyLaunchedFromHomeWidget,
        _now = now ?? DateTime.now;

  /// Set at startup; null when the handler is not running (e.g. tests).
  static AttendanceWidgetLaunchHandler? instance;

  static const scheme = 'myroyal';
  static const host = 'attendance';
  static const openAction = 'open';
  static const actions = {'check_in', 'break_start', 'break_end', 'check_out'};

  /// A tap older than this is not executed (e.g. GPS never became ready).
  static const pendingTtl = Duration(minutes: 2);

  /// The same action tapped again within this window is ignored.
  static const debounce = Duration(seconds: 2);

  final Future<bool> Function() isSignedIn;
  final void Function() openAttendanceTab;
  final Stream<Uri?> _clicks;
  final Future<Uri?> Function() _initialUri;
  final DateTime Function() _now;

  StreamSubscription<Uri?>? _sub;
  AttendanceWidgetActionTarget? _target;
  String? _pending;
  DateTime? _pendingAt;
  String? _lastAction;
  DateTime? _lastActionAt;

  /// Whether a widget tap is waiting for the attendance screen.
  bool get hasPending => _pending != null && !_isExpired;

  bool get _isExpired =>
      _pendingAt != null && _now().difference(_pendingAt!) > pendingTtl;

  /// Returns the action for a widget URI, [openAction] for a bare attendance
  /// link, or null when the URI is not ours.
  static String? parseAction(Uri? uri) {
    if (uri == null || uri.scheme != scheme || uri.host != host) return null;
    final action = uri.queryParameters['action'];
    return actions.contains(action) ? action : openAction;
  }

  Future<void> start() async {
    try {
      await onUri(await _initialUri());
    } catch (e) {
      AppUtils.logApp('WIDGET ::: initial launch uri failed: $e');
    }
    _sub ??= _clicks.listen(onUri);
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    _sub = null;
  }

  Future<void> onUri(Uri? uri) async {
    final action = parseAction(uri);
    if (action == null) return;

    // D4: a tap made while signed out is dropped, never replayed after a
    // (possibly different) user signs in.
    if (!await isSignedIn()) {
      _clearPending();
      return;
    }

    _pending = action;
    _pendingAt = _now();
    openAttendanceTab();
    _dispatch();
  }

  /// Called by the attendance controller when it exists / goes away.
  void attach(AttendanceWidgetActionTarget target) {
    _target = target;
    _dispatch();
  }

  void detach(AttendanceWidgetActionTarget target) {
    if (identical(_target, target)) _target = null;
  }

  void _dispatch() {
    final target = _target;
    final action = _pending;
    if (target == null || action == null) return;

    final expired = _isExpired;
    _clearPending();
    if (expired || action == openAction) return;

    final now = _now();
    if (_lastAction == action &&
        _lastActionAt != null &&
        now.difference(_lastActionAt!) < debounce) {
      return;
    }
    _lastAction = action;
    _lastActionAt = now;
    target.handleWidgetAction(action);
  }

  void _clearPending() {
    _pending = null;
    _pendingAt = null;
  }
}
