import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/home/presentation/views/components/shimmer_text.dart';

import 'package:MyRoyal/app/modules/profile/presentation/views/components/tabs/tab_documents.dart';
import 'package:MyRoyal/app/modules/profile/presentation/views/components/tabs/tab_personal.dart';
import 'package:MyRoyal/app/modules/profile/presentation/views/components/tabs/tab_professional.dart';
import 'package:MyRoyal/app/routes/app_pages.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:MyRoyal/base/widgets/page_base.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'Profil',
      actions: [_editProfile()],
      child: ProfileViewImpl(controller: controller),
    );
  }

  Widget _editProfile() {
    return EPadding(
      padding: const EdgeInsets.only(right: 12),
      child: Obx(
        () => controller.isLoading.value
            ? ShimmerText(height: 20.h, width: 80.w)
            : GestureDetector(
                onTap: () async {
                  await Get.toNamed(
                    Routes.EDIT_PROFILE,
                    arguments: [
                      controller.profileData(),
                      controller.id.value,
                      controller.userData(),
                    ],
                  )?.then((value) {
                    if (value == true) controller.refreshProfile();
                  });
                },
                child: Container(
                  padding: REdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.20),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.4), width: 1),
                  ),
                  child: Text(
                    'Ubah Profil',
                    style: TS.labelSmall.copyWith(
                      color: white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class ProfileViewImpl extends StatelessWidget {
  const ProfileViewImpl({super.key, required this.controller});
  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeroHeader(context),
        _buildTabBar(),
        _buildTabBarView(),
      ],
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    final topPadding = MediaQuery.of(context).viewPadding.top;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: Gradients.primary(),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.20),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(20, topPadding + 64, 20, 24),
      child: Obx(
        () => controller.isLoading.value
            ? _buildLoadingHeader()
            : _buildLoadedHeader(),
      ),
    );
  }

  Widget _buildLoadedHeader() {
    final data = controller.profileData().data;
    final hasPicture = data.personal.profilePicture.isNotEmpty;
    final initial = controller.userData().initialName;

    return Column(
      children: [
        // Avatar with gold ring
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: Gradients.gold(),
          ),
          child: CircleAvatar(
            radius: 40.r,
            backgroundColor: white,
            child: hasPicture
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: data.personal.profilePicture,
                      width: 80.r,
                      height: 80.r,
                      fit: BoxFit.cover,
                      errorWidget: (ctx, url, err) => Center(
                        child: Text(
                          initial,
                          style: TS.titleLarge.copyWith(color: primary),
                        ),
                      ),
                    ),
                  )
                : Text(
                    initial,
                    style: TS.titleLarge.copyWith(color: primary),
                  ),
          ),
        ),
        16.verticalSpace,
        // Name
        Text(
          data.personal.fullName.isNotEmpty ? data.personal.fullName : '-',
          style: TS.titleMedium.copyWith(
            color: white,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
        6.verticalSpace,
        // Email
        if (data.professional.workEmail.isNotEmpty)
          Text(
            data.professional.workEmail,
            style: TS.bodySmall.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        10.verticalSpace,
        // Position + Department badges
        Wrap(
          spacing: 8,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: [
            if (data.professional.position.isNotEmpty)
              _buildBadge(data.professional.position, secondary),
            if (data.professional.department.isNotEmpty)
              _buildBadge(
                  data.professional.department, Colors.white.withOpacity(0.25)),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: REdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        text,
        style: TS.labelSmall.copyWith(
          color: white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLoadingHeader() {
    return Shimmer.fromColors(
      baseColor: Colors.white24,
      highlightColor: Colors.white38,
      child: Column(
        children: [
          CircleAvatar(radius: 40.r, backgroundColor: Colors.white30),
          16.verticalSpace,
          Container(
            width: 140.w,
            height: 16.h,
            color: Colors.white30,
          ),
          8.verticalSpace,
          Container(
            width: 180.w,
            height: 12.h,
            color: Colors.white30,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: white,
      child: TabBar(
        tabAlignment: TabAlignment.fill,
        padding: EdgeInsets.zero,
        controller: controller.tabController,
        indicator: UnderlineTabIndicator(
          borderSide: const BorderSide(width: 2.5, color: secondary),
          insets: REdgeInsets.symmetric(horizontal: 20),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: TS.labelMedium
            .copyWith(color: primary, fontWeight: FontWeight.w700),
        unselectedLabelStyle: TS.labelMedium.copyWith(color: greyText),
        labelColor: primary,
        unselectedLabelColor: greyText,
        tabs: const [
          Tab(text: 'Personal'),
          Tab(text: 'Professional'),
          Tab(text: 'Dokumen'),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        controller: controller.tabController,
        children: [
          TabPersonalView(controller: controller),
          TabProfessionalView(controller: controller),
          TabDocumentsView(controller: controller),
        ],
      ),
    );
  }
}
