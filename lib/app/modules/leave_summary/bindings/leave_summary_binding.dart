import 'package:get/get.dart';

import '../controllers/leave_summary_controller.dart';

class LeaveSummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LeaveSummaryController>(
      () => LeaveSummaryController(),
    );
  }
}
