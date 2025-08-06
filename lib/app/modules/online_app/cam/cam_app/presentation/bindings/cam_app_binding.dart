import 'package:get/get.dart';
import '../controllers/cam_app_controller.dart';

class CamAppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CamAppController>(
      () => CamAppController(),
    );
  }
}
