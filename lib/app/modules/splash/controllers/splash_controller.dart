import 'dart:async';

import 'package:get/get.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/initial_route.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';

class SplashController extends GetxController {
  SplashController({required this.appStorage});

  final AppStorage appStorage;
  final RxBool isLoading = false.obs;

  @override
  onInit() {
    iniData();
    super.onInit();
  }

  Future<void> iniData() async {
    final everLogin = await appStorage.read('ever-login');

    isLoading.value = true;
    AppUtils.logApp('IS LOADING :::${isLoading.value}');
    await Future.delayed(const Duration(milliseconds: 800));
    await checkRoutes();

    if (everLogin == null) {
      isLoading.value = false;
    }
  }

  Future<void> checkRoutes() async {
    final route = await Get.find<InitialRouteImpl>().route;
    if (route != Routes.SPLASH) {
      unawaited(Get.offNamed(route));
    }
  }

  void gotoLogin() {
    Get.offAllNamed(Routes.LOGIN);
  }
}
