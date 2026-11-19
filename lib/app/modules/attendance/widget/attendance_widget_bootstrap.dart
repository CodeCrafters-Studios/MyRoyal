import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/attendance/widget/attendance_widget_launch_handler.dart';
import 'package:MyRoyal/app/modules/attendance/widget/attendance_widget_sync.dart';
import 'package:MyRoyal/app/modules/bottomnavbar/presentation/controllers/bottomnavbar_controller.dart';
import 'package:MyRoyal/app/routes/app_pages.dart';
import 'package:MyRoyal/base/config/app_constants.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';
import 'package:MyRoyal/base/utils/storage/app_storage.dart';

/// Wires the home screen widget into the running app. Call once, after
/// `runApp`, when GetX services (AppStorage) are registered.
Future<void> startAttendanceWidget() async {
  try {
    await AttendanceWidgetSync.configure();

    final handler = AttendanceWidgetLaunchHandler(
      isSignedIn: _isSignedIn,
      openAttendanceTab: _openAttendanceTab,
    );
    AttendanceWidgetLaunchHandler.instance = handler;
    await handler.start();
  } catch (e) {
    AppUtils.logApp('WIDGET ::: start failed: $e');
  }
}

Future<bool> _isSignedIn() async {
  final token = await Get.find<AppStorage>().read(CACHE_ACCESS_TOKEN);
  return token != null && token.isNotEmpty;
}

/// Brings the attendance tab to the front. On a cold start the bottom nav
/// does not exist yet; its `onReady` picks up the pending tap instead.
void _openAttendanceTab() {
  if (!Get.isRegistered<BottomnavbarController>()) return;
  if (Get.currentRoute != Routes.BOTTOMNAVBAR) {
    Get.until((route) => route.settings.name == Routes.BOTTOMNAVBAR);
  }
  Get.find<BottomnavbarController>()
      .selectMenu(BottomnavbarController.attendanceTab);
}
