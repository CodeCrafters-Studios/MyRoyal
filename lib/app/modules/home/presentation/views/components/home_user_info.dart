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
          child: controller.isLoading.value
              ? Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: CardApp(
                    color: primary,
                    isShadow: true,
                    shadows: Shadows.small,
                    padding: REdgeInsets.all(8),
                    margin: REdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HomeUserCard(
                          title: '',
                          subtitle: '',
                          isThridLine: true,
                          thridLineTitle: '',
                          isAvatarPicture: true,
                          avatarPicture:
                              controller.userData().data.profilePicture.isEmpty
                                  ? ''
                                  : controller.userData().data.profilePicture,
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
                  margin: REdgeInsets.fromLTRB(12, 10, 12, 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HomeUserCard(
                        title: controller.userData().data.email.isEmpty
                            ? '-'
                            : controller.userData().data.email,
                        subtitle:
                            '${controller.userData().data.employeeNumber} | ${controller.userData().data.position} | ${controller.userData().data.department}',
                        isThridLine: true,
                        thridLineTitle: controller
                                .userData()
                                .data
                                .joinDate
                                .isEmpty
                            ? '-'
                            : 'Join date: ${controller.userData().data.joinDate}',
                        isImageAvailable: controller.isImageAvailable.value,
                        isAvatarPicture: true,
                        avatarPicture:
                            controller.userData().data.profilePicture.isNotEmpty
                                ? controller.userData().data.profilePicture
                                : '',
                        initial:
                            controller.userData().data.initialName.isNotEmpty
                                ? controller.userData().data.initialName
                                : '',
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
