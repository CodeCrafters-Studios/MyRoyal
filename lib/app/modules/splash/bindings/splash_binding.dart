import 'package:get/get.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(appStorage: Get.find<AppStorage>()),
    );
  }
}
