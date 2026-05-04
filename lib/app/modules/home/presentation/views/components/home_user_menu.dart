import 'package:MyRoyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:MyRoyal/app/modules/home/presentation/views/components/loading_main_menu.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/card/card_app.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:shimmer/shimmer.dart';

class HomeUserMenu extends GetView<HomeController> {
  const HomeUserMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Obx(
        () => controller.isLoading.value
            ? _buildLoading()
            : EPadding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section header
                    Row(
                      children: [
                        Container(
                          width: 3.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            gradient: Gradients.gold(),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        8.horizontalSpace,
                        Text(
                          'All Features',
                          style: TS.titleSmall.copyWith(color: primary),
                        ),
                      ],
                    ),
                    12.verticalSpace,
                    CardApp(
                      color: white,
                      radius: 16,
                      padding: REdgeInsets.all(12),
                      child: controller.isLoading.value
                          ? const LoadingMainMenu()
                          : GridView.count(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 4,
                              shrinkWrap: true,
                              children: controller.mainMenu,
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 16, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: EPadding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: ShimmerText(
                  width: 150.w,
                ),
              ),
            ),
            ShimmerText(
              width: Get.width * .9,
              height: 132.h,
            ),
          ],
        ),
      ),
    );
  }
}
