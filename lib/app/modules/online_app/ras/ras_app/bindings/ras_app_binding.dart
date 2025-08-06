import 'package:get/get.dart';

import '../controllers/ras_app_controller.dart';

class RasAppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RasAppController>(
      () => RasAppController(),
    );
  }
}
