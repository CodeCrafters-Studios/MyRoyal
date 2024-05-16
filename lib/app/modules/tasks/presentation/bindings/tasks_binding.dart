import 'package:get/get.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';

import '../controllers/tasks_controller.dart';

class TasksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TasksController>(
      () => TasksController(appDialog: Get.find<AppDialogImpl>()),
    );
  }
}
