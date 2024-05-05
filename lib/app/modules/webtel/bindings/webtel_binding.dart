import 'package:get/get.dart';

import '../controllers/webtel_controller.dart';

class WebtelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebtelController>(
      () => WebtelController(),
    );
  }
}
