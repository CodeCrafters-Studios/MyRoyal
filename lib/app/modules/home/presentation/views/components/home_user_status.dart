import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/home_user_card.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';
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
              controller.isLoading.value
                  ? Align(
                      alignment: Alignment.topLeft,
                      child: EPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: ShimmerText(
                          width: 150.w,
                        ),
                      ),
                    )
                  : _buildLeaveSummary(),
              15.verticalSpace,
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
                                title: '',
                                subtitle: '',
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
                                title: '',
                                subtitle: '',
                                isThridLine: false,
                                suffixIcon: false,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CardApp(
                          color: green,
                          outlineColor: black,
                          child: SizedBox(
                            width: 155.w,
                            child: HomeUserCard(
                              shapeBorder: true,
                              isAvatarPicture: false,
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
                              suffixIcon: false,
                            ),
                          ),
                        ),
                        CardApp(
                          color: secondary10,
                          outlineColor: black,
                          child: SizedBox(
                            width: 155.w,
                            child: HomeUserCard(
                              shapeBorder: true,
                              isAvatarPicture: false,
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
                              suffixIcon: false,
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

  Widget _buildLeaveSummary() {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 21),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Leave Summary', style: TS.titleMedium),
          InkWellTap(
            onTap: () => Get.toNamed(Routes.LEAVE_SUMMARY),
            child: const Icon(Icons.arrow_forward_rounded),
          ),
        ],
      ),
    );
  }
}
