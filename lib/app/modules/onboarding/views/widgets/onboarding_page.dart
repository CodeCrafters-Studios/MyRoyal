import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:lottie/lottie.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.lottieImage,
    this.lottieImage2 = 'assets/json/lottie_onboarding1_layer_2.json',
    required this.subtitle,
    required this.subtitle2,
    this.width = 280,
    this.isDoubleLayer = false,
  });

  final String lottieImage, lottieImage2, subtitle, subtitle2;
  final double width;
  final bool isDoubleLayer;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isDoubleLayer ? 130.verticalSpace : const Spacer(flex: 2),
        isDoubleLayer
            ? Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 312.h,
                  child: Stack(
                    children: [
                      Positioned(
                        child: Lottie.asset(
                          width: width.w,
                          lottieImage2,
                        ),
                      ),
                      Positioned(
                        left: 20.w,
                        top: 73.h,
                        child: Lottie.asset(
                          width: width.w,
                          lottieImage,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Lottie.asset(
                width: width.w,
                lottieImage,
              ),
        const Spacer(),
        EPadding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TS.titleLarge.copyWith(color: primary),
              ),
              Container(
                padding: REdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: secondary2,
                ),
                child: Text(
                  subtitle2,
                  textAlign: TextAlign.center,
                  style: TS.titleLarge.copyWith(color: white),
                ),
              ),
            ],
          ),
        ),
        isDoubleLayer ? 174.verticalSpace : const Spacer(flex: 2),
      ],
    );
  }
}
