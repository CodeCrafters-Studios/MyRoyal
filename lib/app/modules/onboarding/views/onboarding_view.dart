import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/onboarding/views/widgets/onboarding_page.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/padding.dart';

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
                        ? 'Welcome !'
                        : controller.currentPageIndex.value == 1
                            ? 'Quick & Easy to Use'
                            : 'Ready to Start?',
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
                  subtitle: 'YOUR DAILY TASKS',
                  subtitle2: 'ALL IN ONE APP',
                ),
                OnboardingPage(
                  lottieImage: 'assets/json/lottie_onboarding1_layer_1.json',
                  subtitle: 'IMPROVE YOUR ALL',
                  subtitle2: 'REQUESTS EASILY',
                  isDoubleLayer: true,
                ),
                OnboardingPage(
                  lottieImage: 'assets/json/lottie_onboarding3.json',
                  subtitle: 'ACCESS ALL THE TOOLS YOU',
                  subtitle2: 'NEED USING MYROYAL',
                ),
              ],
            ),
            controller.currentPageIndex.value == 1 ||
                    controller.currentPageIndex.value == 2
                ? Align(
                    alignment: Alignment.bottomCenter,
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
                          text: 'Back',
                          textColor: black,
                          onPressed: controller.previousPage,
                        ),
                        10.horizontalSpace,
                        ButtonPrimary(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          margin: const EdgeInsets.only(
                            bottom: 50,
                          ),
                          text: controller.currentPageIndex.value == 2
                              ? 'Let\'s Start'
                              : 'Continue',
                          onPressed: controller.currentPageIndex.value == 2
                              ? controller.goToLogin
                              : controller.nextPage,
                        ),
                      ],
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
                      text: 'Continue',
                      onPressed: controller.nextPage,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
