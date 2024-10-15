import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/home_slide.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/home_user_info.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/home_user_menu.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/home_user_status.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/image.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';
import 'package:iroyal/base/widgets/padding.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        centerTitle: false,
        scrolledUnderElevation: 0.0,
        backgroundColor: white,
        automaticallyImplyLeading: false,
        toolbarHeight: 70.h,
        title: _buildTitle(),
        actions: [
          _buildNotifications(),
          15.horizontalSpace,
          _buildLogo(),
        ],
      ),
      body: RefreshIndicator(
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
    );
  }

  Widget _buildNotifications() {
    return Obx(
      () => Badge(
        label: Text(controller.filterNewNotif.length.toString()),
        child: InkWellTap(
          onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
          child: Icon(
            Icons.notifications,
            color: secondary,
            size: 32.dm,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return EPadding(
      padding: const EdgeInsets.only(left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome Back!👋",
            style: TS.bodyMedium,
          ),
          Obx(
            () => controller.isLoading.value
                ? _buildLoadingText()
                : _buildLoadedText(),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return EPadding(
      padding: const EdgeInsets.only(right: 20),
      child: EImages(
        name: "assets/images/img_logo.png",
        height: 55.h,
      ),
    );
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
      style:
          TS.labelLarge.copyWith(color: primary, fontWeight: FontWeight.bold),
    );
  }
}
