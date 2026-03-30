import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/home/presentation/views/components/home_slide.dart';
import 'package:MyRoyal/app/modules/home/presentation/views/components/home_user_info.dart';
import 'package:MyRoyal/app/modules/home/presentation/views/components/home_user_menu.dart';
import 'package:MyRoyal/app/modules/home/presentation/views/components/home_user_status.dart';
import 'package:MyRoyal/app/modules/home/presentation/views/components/shimmer_text.dart';
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
        backgroundColor: white,
        appBar: AppBar(
          centerTitle: false,
          scrolledUnderElevation: 0.0,
          backgroundColor: primary,
          automaticallyImplyLeading: false,
          toolbarHeight: 70.h,
          title: _buildTitle(),
          actions: [
            _buildNotifications(),
            15.horizontalSpace,
            _buildLogo(),
          ],
        ),
        body: Stack(children: [
          Image.asset(
            'assets/images/img_bg_page.png',
            fit: BoxFit.cover,
          ),
          RefreshIndicator(
            backgroundColor: white,
            color: primary,
            onRefresh: controller.onRefresh,
            child: CustomScrollView(
              scrollDirection: Axis.vertical,
              slivers: [
                const HomeUserInfo(),
                const HomeUserStatus(),
                const HomeUserMenu(),
                HomeSlide(
                  controller: controller,
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildNotifications() {
    return Obx(
      () => controller.isLoading.value
          ? Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Corners.xsRadius,
                  ),
                  border: Border.all(color: grey),
                  color: greyText,
                ),
                height: 27.h,
                width: 27.w,
              ),
            )
          : controller.userData.value.data.countNotification != 0
              ? Badge(
                  label: Text(
                    controller.userData.value.data.countNotification.toString(),
                    style: TS.caption,
                  ),
                  child: GestureDetector(
                    onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
                    child: SvgPicture.asset(
                      height: 27.h,
                      'assets/icons/ic_notifications.svg',
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
                  child: SvgPicture.asset(
                    height: 27.h,
                    'assets/icons/ic_notifications.svg',
                  ),
                ),
    );
  }

  Widget _buildTitle() {
    return Obx(
      () => EPadding(
        padding: const EdgeInsets.only(left: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            controller.isLoading.value
                ? ShimmerText(
                    padding: REdgeInsets.only(left: 8, top: 5, bottom: 8),
                    margin: REdgeInsets.only(bottom: 5),
                    width: 150.w,
                  )
                : Text(
                    "Hi.. Welcome Back!👋",
                    style: TS.bodyMedium.copyWith(color: white),
                  ),
            controller.isLoading.value
                ? _buildLoadingText()
                : _buildLoadedText(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingLogo() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: EPadding(
        padding: const EdgeInsets.only(right: 20),
        child: EImages(
          name: "assets/images/img_logo.png",
          height: 55.h,
        ),
      ),
    );
  }

  Widget _buildLoadedLogo() {
    return EPadding(
      padding: const EdgeInsets.only(right: 20),
      child: EImages(
        name: "assets/images/img_logo.png",
        height: 55.h,
      ),
    );
  }

  Widget _buildLogo() {
    return Obx(() =>
        controller.isLoading.value ? _buildLoadingLogo() : _buildLoadedLogo());
  }

  Widget _buildLoadingText() {
    return ShimmerText(
      padding: REdgeInsets.only(left: 8, top: 5, bottom: 8),
      margin: REdgeInsets.only(top: 5),
      width: 80,
    );
  }

  Widget _buildLoadedText() {
    return Text(
      controller.userData().data.fullName,
      style: TS.labelLarge.copyWith(color: white, fontWeight: FontWeight.bold),
    );
  }
}
