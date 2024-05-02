import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/home_user_card.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:shimmer/shimmer.dart';

class HomeUserStatus extends GetView<HomeController> {
  const HomeUserStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: EPadding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Obx(
          () => Column(
            children: [
              controller.isLoading.value
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: const Align(
                        alignment: Alignment.topLeft,
                        child: EPadding(
                          padding: EdgeInsets.symmetric(horizontal: 18),
                          child: ShimmerText(
                            width: 150,
                          ),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        EPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Text(
                            "Activity for Today",
                            style: TS.titleMedium,
                          ),
                        )
                      ],
                    ),
              20.verticalSpace,
              controller.isLoading.value
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CardApp(
                            color: primary.withOpacity(0.8),
                            outlineColor: black,
                            child: SizedBox(
                              width: 155.w,
                              child: const HomeUserCard(
                                shapeBorder: true,
                                isAvatarPicture: false,
                                title: 'Today In',
                                subtitle: '00:00:00',
                                isThridLine: false,
                                suffixIcon: false,
                              ),
                            ),
                          ),
                          20.horizontalSpace,
                          CardApp(
                            color: grey,
                            outlineColor: black,
                            child: SizedBox(
                              width: 155.w,
                              child: const HomeUserCard(
                                shapeBorder: true,
                                isAvatarPicture: false,
                                title: 'Yesterday Out',
                                subtitle: '00:00:00',
                                isThridLine: false,
                                suffixIcon: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CardApp(
                          color: primary.withOpacity(0.8),
                          outlineColor: black,
                          child: SizedBox(
                            width: 155.w,
                            child: HomeUserCard(
                              shapeBorder: true,
                              isAvatarPicture: false,
                              title: 'Today In',
                              subtitle: controller.userData.value.attendance
                                      .todayCheckin.isEmpty
                                  ? "00:00:00"
                                  : controller
                                      .userData.value.attendance.todayCheckin
                                      .split(' ')[1]
                                      .substring(0, 8),
                              isThridLine: false,
                              textColor: white,
                              backgroundColor: white,
                              borderSideColor: greyHint,
                              suffixIcon: false,
                            ),
                          ),
                        ),
                        20.horizontalSpace,
                        CardApp(
                          color: grey,
                          outlineColor: black,
                          child: SizedBox(
                            width: 155.w,
                            child: HomeUserCard(
                              shapeBorder: true,
                              isAvatarPicture: false,
                              title: 'Yesterday Out',
                              subtitle: controller.userData.value.attendance
                                      .yesterdayCheckout.isEmpty
                                  ? "00:00:00"
                                  : controller.userData.value.attendance
                                      .yesterdayCheckout
                                      .split(' ')[1]
                                      .substring(0, 8),
                              isThridLine: false,
                              textColor: black,
                              backgroundColor: white,
                              borderSideColor: greyHint,
                              suffixIcon: false,
                            ),
                          ),
                        ),
                      ],
                    ),
              10.verticalSpace
            ],
          ),
        ),
      ),
    );
  }
}
