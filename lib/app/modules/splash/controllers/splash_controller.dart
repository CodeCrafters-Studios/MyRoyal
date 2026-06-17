import 'dart:async';
import 'dart:io';

import 'package:MyRoyal/app/shared/services/in_app_review_service.dart';
import 'package:MyRoyal/base/config/app_config.dart';
import 'package:MyRoyal/base/config/environment_config.dart';
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
    if (AppConfig.environment.environment == EnvironmentType.production) {
      final info = await deviceInfo.info();
      if (!info.isPhysicalDevice) {
        AppDialogImpl().showErrorDialog(
          title: "Emulator Terdeteksi",
          description:
              "Aplikasi ini tidak dapat dijalankan di emulator atau perangkat virtual demi alasan keamanan.",
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
    }

    final everLogin = await appStorage.read('ever-login');

    // Track usage count on startup
    final reviewService = InAppReviewService();
    await reviewService.incrementUsageCount(appStorage);

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
