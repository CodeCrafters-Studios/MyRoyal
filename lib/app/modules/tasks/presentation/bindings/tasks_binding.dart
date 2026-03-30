import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/detail_tasks/controllers/detail_tasks_controller.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';

import '../controllers/tasks_controller.dart';

class TasksBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<TasksController>(
        () => TasksController(appDialog: Get.find<AppDialogImpl>()),
      )

      // Detail Tasks
      ..lazyPut<DetailTasksController>(
        () => DetailTasksController(),
      );
  }
}
