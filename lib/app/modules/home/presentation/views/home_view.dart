import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/home/presentation/views/components/home_slide.dart';
import 'package:MyRoyal/app/modules/home/presentation/views/components/home_user_info.dart';
import 'package:MyRoyal/app/modules/home/presentation/views/components/home_user_menu.dart';
import 'package:MyRoyal/app/modules/home/presentation/views/components/home_user_status.dart';
import 'package:MyRoyal/app/routes/app_pages.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/image.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:shimmer/shimmer.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: bgColor,
        body: Column(
          children: [
            _buildGradientHeader(context),
            Expanded(
              child: RefreshIndicator(
                backgroundColor: white,
                color: secondary,
                onRefresh: controller.onRefresh,
                child: CustomScrollView(
                  scrollDirection: Axis.vertical,
                  slivers: [
                    const HomeUserInfo(),
                    const HomeUserStatus(),
                    const HomeUserMenu(),
                    HomeSlide(controller: controller),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Premium gradient header with user greeting + notification + logo
  Widget _buildGradientHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).viewPadding.top;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: Gradients.primary(),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, topPadding + 14, 16, 16),
        child: Row(
          children: [
            Expanded(child: _buildTitle()),
            _buildNotifications(),
            12.horizontalSpace,
            _buildLogo(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotifications() {
    return Obx(
      () => controller.isLoading.value
          ? Shimmer.fromColors(
              baseColor: Colors.white24,
              highlightColor: Colors.white38,
              child: Container(
                width: 25.w,
                height: 25.h,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            )
          : GestureDetector(
              onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 24.w,
                    height: 24.h,
                    child: SvgPicture.asset(
                      'assets/icons/ic_notifications.svg',
                      width: 20.w,
                      height: 20.w,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  if (controller.userData.value.data.countNotification != 0)
                    Positioned(
                      top: -6,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: secondary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          controller.userData.value.data.countNotification
                              .toString(),
                          style: TS.caption.copyWith(
                            color: white,
                            fontSize: 9.sp,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildTitle() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          controller.isLoading.value
              ? Shimmer.fromColors(
                  baseColor: Colors.white24,
                  highlightColor: Colors.white38,
                  child: Container(
                    width: 130.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                )
              : Text(
                  "Hi, Selamat Datang! 👋",
                  style: TS.bodyMedium.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
          4.verticalSpace,
          controller.isLoading.value
              ? Shimmer.fromColors(
                  baseColor: Colors.white24,
                  highlightColor: Colors.white38,
                  child: Container(
                    width: 100.w,
                    height: 16.h,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                )
              : Text(
                  controller.userData().data.fullName,
                  style: TS.titleSmall.copyWith(
                    color: white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Obx(
      () => controller.isLoading.value
          ? Shimmer.fromColors(
              baseColor: Colors.white24,
              highlightColor: Colors.white38,
              child: Container(
                width: 50.w,
                height: 50.h,
                color: Colors.white24,
              ),
            )
          : EPadding(
              padding: const EdgeInsets.only(right: 4),
              child: EImages(
                name: "assets/images/img_logo.png",
                height: 50.h,
              ),
            ),
    );
  }
}
