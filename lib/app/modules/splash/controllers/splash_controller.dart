import 'package:get/get.dart';
import 'package:iroyal/app/routes/app_pages.dart';

class SplashController extends GetxController {
  void gotoLogin() {
    Get.toNamed(Routes.LOGIN);
  }
}
