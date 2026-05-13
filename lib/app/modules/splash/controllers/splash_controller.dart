import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/routes/app_pages.dart';
import 'package:MyRoyal/base/utils/get_device_info.dart';
import 'package:MyRoyal/base/utils/initial_route.dart';
import 'package:MyRoyal/base/utils/storage/app_storage.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';

class SplashController extends GetxController {
  SplashController({required this.appStorage, required this.deviceInfo});

  final AppStorage appStorage;
  final DeviceInfo deviceInfo;
  final RxBool isLoading = false.obs;

  @override
  onInit() {
    _initData();
    super.onInit();
  }

  Future<void> _initData() async {
    final info = await deviceInfo.info();
    if (!info.isPhysicalDevice) {
      AppDialogImpl().showErrorDialog(
        title: "Emulator Terdeteksi",
        description: "Aplikasi ini tidak dapat dijalankan di emulator atau perangkat virtual demi alasan keamanan.",
        textButton: "Tutup Aplikasi",
        onPress: () {
          if (Platform.isAndroid) {
            SystemNavigator.pop();
          } else {
            exit(0);
          }
        },
      );
      return;
    }

    final everLogin = await appStorage.read('ever-login');

    isLoading.value = true;
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

  void goToOnBoarding() {
    Get.offAllNamed(Routes.ONBOARDING);
  }
}
