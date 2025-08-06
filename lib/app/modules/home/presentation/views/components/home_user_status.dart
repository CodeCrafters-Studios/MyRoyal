import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/home_user_card.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/card/card_app.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:shimmer/shimmer.dart';

class HomeUserStatus extends GetView<HomeController> {
  const HomeUserStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Obx(
        () => EPadding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Column(
            children: [
              10.verticalSpace,
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
                                title: '',
                                subtitle: '',
                                isThridLine: false,
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
                                title: '',
                                subtitle: '',
                                isThridLine: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 160.w,
                          child: CardApp(
                            color: primary2,
                            outlineColor: black,
                            isShadow: true,
                            shadows: Shadows.universal,
                            child: HomeUserCard(
                              shapeBorder: true,
                              title: "Last Check In",
                              subtitle: controller.userData.value.data
                                      .absentStartDay.isNotEmpty
                                  ? controller
                                      .userData.value.data.absentStartDay
                                  : '-',
                              thridLineTitle: controller.userData.value.data
                                      .absentStartTime.isNotEmpty
                                  ? controller
                                      .userData.value.data.absentStartTime
                                  : '00:00:00',
                              isThridLine: true,
                              textColor: white,
                              backgroundColor: white,
                              borderSideColor: greyHint,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 160.w,
                          child: CardApp(
                            color: secondary,
                            outlineColor: black,
                            child: HomeUserCard(
                              shapeBorder: true,
                              title: 'Last Check Out',
                              subtitle: controller.userData.value.data
                                      .absentEndDay.isNotEmpty
                                  ? controller.userData.value.data.absentEndDay
                                  : '-',
                              thridLineTitle: controller.userData.value.data
                                      .absentEndTime.isNotEmpty
                                  ? controller.userData.value.data.absentEndTime
                                  : '00:00:00',
                              isThridLine: true,
                              textColor: white,
                              backgroundColor: white,
                              borderSideColor: greyHint,
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
