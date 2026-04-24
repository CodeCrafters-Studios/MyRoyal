import 'package:MyRoyal/app/modules/attendance/data/models/attendance_shift_schedule_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class AttendanceReminderService {
  AttendanceReminderService._();

  static final AttendanceReminderService instance =
      AttendanceReminderService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int breakReminderId = 1001;
  static const int checkout5MinId = 1002;
  static const int checkoutLateId = 1003;
  static const int checkoutEscalationId = 1004;

  Future<void> init() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(
      android: android,
    );

    await _plugin.initialize(
      settings,
    );
  }

  NotificationDetails get _details {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "attendance_channel",
        "Attendance Reminder",
        channelDescription: "Silent attendance reminders",
        importance: Importance.high,
        priority: Priority.high,
        playSound: false,
        enableVibration: false,
      ),
    );
  }

  Future<void> _schedule({
    required int id,
    required String title,
    required String body,
    required DateTime date,
  }) async {
    if (date.isBefore(
      DateTime.now(),
    )) {
      return;
    }

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(
        date,
        tz.local,
      ),
      _details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /*
  ==========================================
  BREAK
  ==========================================
   */

  Future<void> scheduleBreakReminder(DateTime breakStart) async {
    // Notify 5 minutes before break starts
    await _schedule(
      id: breakReminderId,
      title: "Break Reminder",
      body: "Break starts in 5 minutes",
      date: breakStart.subtract(const Duration(minutes: 5)), // ✅ correct
    );
  }

  /*
  ==========================================
  CHECKOUT
  ==========================================
   */

  Future<void> scheduleCheckoutSequence(DateTime shiftEnd) async {
    // FIX: 5 min BEFORE shift ends (was scheduling AT shiftEnd)
    await _schedule(
      id: checkout5MinId,
      title: "Checkout Reminder",
      body: "Checkout in 5 minutes",
      date: shiftEnd
          .subtract(const Duration(minutes: 5)), // was: shiftEnd (no subtract)
    );

    // AT shiftEnd + 10 min
    await _schedule(
      id: checkoutLateId,
      title: "Missed Checkout",
      body: "You haven't checked out yet",
      date: shiftEnd.add(const Duration(minutes: 10)),
    );

    // AT shiftEnd + 35 min
    await _schedule(
      id: checkoutEscalationId,
      title: "Escalation Reminder",
      body: "Please complete checkout immediately",
      date: shiftEnd.add(const Duration(minutes: 35)),
    );
  }
  /*
  ==========================================
  SHIFT RULES
  ==========================================
   */

  Future<void> scheduleByShift(
    AttendanceShiftScheduleModel shift,
  ) async {
    await cancelAll();

    /// break reminder only if both exist
    if (shift.breakStart != null && shift.breakEnd != null) {
      await scheduleBreakReminder(
        shift.breakStart!,
      );
    }

    await scheduleCheckoutSequence(
      shift.shiftEnd,
    );
  }

  /*
  ==========================================
  CANCEL
  ==========================================
   */

  Future<void> cancelCheckoutSequence() async {
    await _plugin.cancel(
      checkout5MinId,
    );

    await _plugin.cancel(
      checkoutLateId,
    );

    await _plugin.cancel(
      checkoutEscalationId,
    );
  }

  Future<void> cancelBreakReminder() async {
    await _plugin.cancel(
      breakReminderId,
    );
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
