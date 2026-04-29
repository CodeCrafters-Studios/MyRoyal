import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:MyRoyal/base/initialization/firebase_messaging_callbacks.dart';

/// Notification IDs — must be stable so we can cancel/replace them.
class AttendanceNotificationIds {
  static const int checkIn = 1001;
  static const int breakStart = 1002;
  static const int breakEnd = 1003;
  static const int checkOut = 1004;
  static const int checkInReminder = 1011;
  static const int breakEndReminder = 1012;
  static const int checkOutReminder = 1013;
}

/// Attendance notification channel
class _AttendanceChannel {
  static const String id = 'attendance_channel';
  static const String name = 'Attendance Reminders';
  static const String description =
      'Reminders for check-in, break, and check-out events.';
}

/// Service that handles all local notification logic for the attendance feature.
class AttendanceNotificationService {
  AttendanceNotificationService._();

  static final AttendanceNotificationService instance =
      AttendanceNotificationService._();

  // ── Core helpers ──────────────────────────────────────────────────────────

  AndroidNotificationDetails get _androidDetails =>
      const AndroidNotificationDetails(
        _AttendanceChannel.id,
        _AttendanceChannel.name,
        channelDescription: _AttendanceChannel.description,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
      );

  NotificationDetails get _notificationDetails =>
      NotificationDetails(android: _androidDetails);

  Future<void> _show({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      _notificationDetails,
      payload: payload,
    );
  }

  Future<void> _cancel(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  // ── Public API ────────────────────────────────────────────────────────────

  /// Show an immediate notification when the user successfully checks in.
  Future<void> showCheckInSuccess() async {
    await _show(
      id: AttendanceNotificationIds.checkIn,
      title: '✅ Check-In Berhasil',
      body: 'Anda telah berhasil melakukan check-in. Semangat bekerja!',
      payload: 'Attendance',
    );
  }

  /// Show an immediate notification when the user starts a break.
  Future<void> showBreakStartSuccess() async {
    await _show(
      id: AttendanceNotificationIds.breakStart,
      title: '☕ Istirahat Dimulai',
      body: 'Waktu istirahat Anda telah dimulai. Nikmati waktu istirahatmu!',
      payload: 'Attendance',
    );
  }

  /// Show an immediate notification when the user ends their break.
  Future<void> showBreakEndSuccess() async {
    await _show(
      id: AttendanceNotificationIds.breakEnd,
      title: '💼 Kembali Bekerja',
      body: 'Waktu istirahat selesai. Saatnya kembali bekerja!',
      payload: 'Attendance',
    );
  }

  /// Show an immediate notification when the user checks out.
  Future<void> showCheckOutSuccess() async {
    await _show(
      id: AttendanceNotificationIds.checkOut,
      title: '🏁 Check-Out Berhasil',
      body: 'Kerja keras hari ini sudah tercatat. Sampai jumpa besok!',
      payload: 'Attendance',
    );
  }

  /// Cancel all pending attendance reminder notifications.
  Future<void> cancelAllAttendanceNotifications() async {
    await _cancel(AttendanceNotificationIds.checkIn);
    await _cancel(AttendanceNotificationIds.breakStart);
    await _cancel(AttendanceNotificationIds.breakEnd);
    await _cancel(AttendanceNotificationIds.checkOut);
    await _cancel(AttendanceNotificationIds.checkInReminder);
    await _cancel(AttendanceNotificationIds.breakEndReminder);
    await _cancel(AttendanceNotificationIds.checkOutReminder);
  }
}
