import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/routes/app_pages.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';
import 'package:MyRoyal/base/utils/storage/app_storage.dart';

class OnboardingController extends GetxController {
  OnboardingController({
    required this.appStorage,
  });

  final pageController = PageController();
  final AppStorage appStorage;
  Rx<int> currentPageIndex = 0.obs;

  void updatePageIndicator(int index) {
    currentPageIndex.value = index;
    AppUtils.logApp('${currentPageIndex.value}');
    AppUtils.logApp('here');
  }

  void nextPage() {
    int page = currentPageIndex.value + 1;
    pageController.jumpToPage(page);
  }

  void previousPage() {
    int page = currentPageIndex.value - 1;
    pageController.jumpToPage(page);
  }

  void goToLogin() {
    appStorage.write('ever-login', 'false');
    Get.offAllNamed(Routes.LOGIN);
  }
}
