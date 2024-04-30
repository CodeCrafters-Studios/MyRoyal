import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/home_user_card.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:shimmer/shimmer.dart';

class HomeUserInfo extends GetView<HomeController> {
  const HomeUserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Obx(
        () => EPadding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: controller.isLoading.value == true
              ? Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: CardApp(
                    color: primary,
                    isShadow: true,
                    shadows: Shadows.small,
                    padding: REdgeInsets.all(8),
                    margin: REdgeInsets.all(16),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HomeUserCard(
                          title: '',
                          subtitle: '',
                          isThridLine: true,
                          thridLineTitle: '',
                          isAvatarPicture: true,
                          suffixIcon: false,
                        ),
                      ],
                    ),
                  ),
                )
              : CardApp(
                  color: primary,
                  isShadow: true,
                  shadows: Shadows.small,
                  padding: REdgeInsets.all(8),
                  margin: REdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HomeUserCard(
                        title: controller.userData.value.email,
                        subtitle:
                            '${controller.userData.value.job.employeeNumber} | ${controller.userData.value.job.position} | ${controller.userData.value.job.department}',
                        isThridLine: true,
                        thridLineTitle:
                            'Join date: ${controller.userData.value.job.joinDate}',
                        isAvatarPicture: true,
                        suffixIcon: false,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
