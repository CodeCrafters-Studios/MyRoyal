import 'package:get/get.dart';

import '../controllers/attendance_summary_controller.dart';

class AttendanceSummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AttendanceSummaryController>(
      () => AttendanceSummaryController(),
    );
  }
}
