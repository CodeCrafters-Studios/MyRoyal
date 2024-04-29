import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/image.dart';
import 'package:iroyal/base/widgets/page_base.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return PageBase(
      appBar: emptyBox,
      showBackground: false,
      child: Stack(
        children: [
          Center(
            child: const EImages(
              width: 200,
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
            bottom: .1.sh,
            right: 0,
            left: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ButtonPrimary(
                color: primary,
                key: const Key('splashLoginBtn'),
                onPressed: controller.gotoLogin,
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
        ],
      ),
    );
  }
}
