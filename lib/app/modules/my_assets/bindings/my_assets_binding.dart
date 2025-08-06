import 'package:get/get.dart';

import '../controllers/my_assets_controller.dart';

class MyAssetsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyAssetsController>(
      () => MyAssetsController(),
    );
  }
}
