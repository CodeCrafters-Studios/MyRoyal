import 'package:get/get.dart';

import '../controllers/detail_tasks_controller.dart';

class DetailTasksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailTasksController>(
      () => DetailTasksController(),
    );
  }
}
