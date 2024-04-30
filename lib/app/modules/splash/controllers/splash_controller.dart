import 'dart:async';

import 'package:get/get.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/utils/initial_route.dart';

class SplashController extends GetxController {
  @override
  onInit() {
    iniData();
    super.onInit();
  }

  Future<void> iniData() async {
    await checkRoutes();
  }

  Future<void> checkRoutes() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final route = await Get.find<InitialRouteImpl>().route;
    if (route != Routes.SPLASH) {
      unawaited(Get.offNamed(route));
    }
  }

  void gotoLogin() {
    Get.toNamed(Routes.LOGIN);
  }
}
