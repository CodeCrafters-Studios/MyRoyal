import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/image.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return PageBase(
      appBar: emptyBox,
      showBackground: false,
      child: Obx(
        () => controller.isLoading.value
            ? Center(
                child: EImages(
                width: 200.r,
                name: 'assets/images/img_logo.png',
              ))
            : Stack(
                children: [
                  Center(
                    child: EImages(
                      width: 200.r,
                      name: 'assets/images/img_logo.png',
                    ).animate().fadeIn(
                          duration: const Duration(milliseconds: 1500),
                          curve: Curves.ease,
                        ),
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/img_gradient_circle.png',
                      width: Get.width,
                      height: Get.width,
                      fit: BoxFit.fill,
                    ),
                  )
                      .animate(
                        delay: const Duration(milliseconds: 1300),
                      )
                      .scale(
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.ease,
                      )
                      .fadeOut(
                        duration: const Duration(milliseconds: 1000),
                      ),
                  Positioned(
                    bottom: .15.sh,
                    right: 0,
                    left: 0,
                    child: EPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: ButtonPrimary(
                        color: primary,
                        key: const Key('splashLoginBtn'),
                        onPressed: controller.goToOnBoarding,
                        fullWidth: true,
                        text: 'Continue',
                        textColor: white,
                      ),
                    ),
                  )
                      .animate(
                        delay: const Duration(milliseconds: 1900),
                      )
                      .fadeIn()
                      .slide(
                        duration: const Duration(milliseconds: 1700),
                        curve: Curves.ease,
                        begin: const Offset(0, 3),
                      ),
                  Positioned(
                    bottom: .04.sh,
                    right: 0,
                    left: 0,
                    child: EPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          Text(
                            'Copyright @ 2024 Royal Corporation.\nAll Right Reserved.',
                            style: TS.bodySmall
                                .copyWith(fontWeight: FontWeight.w200),
                            textAlign: TextAlign.center,
                          ),
                          10.verticalSpace,
                          Text(
                            'Version ${controller.deviceInfo.packageInfo.version}',
                            style: TS.bodySmall
                                .copyWith(fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate(
                        delay: const Duration(milliseconds: 1900),
                      )
                      .fadeIn()
                      .slide(
                        duration: const Duration(milliseconds: 1700),
                        curve: Curves.ease,
                        begin: const Offset(0, 3),
                      ),
                ],
              ),
      ),
    );
  }
}
