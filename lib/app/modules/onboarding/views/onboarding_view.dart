import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/onboarding/views/widgets/onboarding_page.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/buttons/button_primary.dart';
import 'package:MyRoyal/base/widgets/padding.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            Image.asset(
              'assets/images/img_bg_onboarding1.png',
              height: Get.height,
              fit: BoxFit.fill,
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  50.verticalSpace,
                  Text(
                    controller.currentPageIndex.value == 0
                        ? 'Selamat Datang !'
                        : controller.currentPageIndex.value == 1
                            ? 'Mudah & Cepat Digunakan'
                            : 'Siap Untuk Memulai?',
                    style: TS.titleLarge.copyWith(color: primary),
                  ),
                  30.verticalSpace,
                  EPadding(
                    padding: REdgeInsets.symmetric(horizontal: 50),
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      borderRadius: const BorderRadius.all(Radius.circular(28)),
                      color: primary,
                      backgroundColor: greyHint,
                      value: controller.currentPageIndex.value == 0
                          ? 0.1
                          : controller.currentPageIndex.value == 1
                              ? 0.5
                              : 1,
                    ),
                  ),
                ],
              ),
            ),
            PageView(
              controller: controller.pageController,
              onPageChanged: controller.updatePageIndicator,
              children: const [
                OnboardingPage(
                  lottieImage: 'assets/json/lottie_onboarding2.json',
                  subtitle: 'TUGAS HARIAN ANDA',
                  subtitle2: 'SEMUA DALAM SATU APLIKASI',
                ),
                OnboardingPage(
                  lottieImage: 'assets/json/lottie_onboarding1_layer_1.json',
                  subtitle: 'TINGKATKAN SEMUA',
                  subtitle2: 'PERMINTAAN ANDA DENGAN MUDAH',
                  isDoubleLayer: true,
                ),
                OnboardingPage(
                  lottieImage: 'assets/json/lottie_onboarding3.json',
                  subtitle: 'DAPATKAN SEMUA TOOLS YANG',
                  subtitle2: 'ANDA BUTUHKAN MENGGUNAKAN MYROYAL',
                ),
              ],
            ),
            controller.currentPageIndex.value == 1 ||
                    controller.currentPageIndex.value == 2
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: EPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonPrimary(
                            color: white,
                            borderSide: const BorderSide(color: primary),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            margin: const EdgeInsets.only(
                              bottom: 50,
                            ),
                            text: 'Kembali',
                            textColor: black,
                            onPressed: controller.previousPage,
                          ),
                          10.horizontalSpace,
                          Expanded(
                            child: ButtonPrimary(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 60),
                              margin: const EdgeInsets.only(
                                bottom: 50,
                              ),
                              text: controller.currentPageIndex.value == 2
                                  ? 'Mulai'
                                  : 'Lanjut',
                              onPressed: controller.currentPageIndex.value == 2
                                  ? controller.goToLogin
                                  : controller.nextPage,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: ButtonPrimary(
                      fullWidth: true,
                      margin: const EdgeInsets.only(
                        left: 40,
                        right: 40,
                        bottom: 50,
                      ),
                      text: 'Lanjut',
                      onPressed: controller.nextPage,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
