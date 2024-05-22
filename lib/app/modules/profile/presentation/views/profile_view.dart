import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:iroyal/app/modules/settings/presentation/views/components/item_menu_settings.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/others/coming_soon.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: InkWell(
          onTap: Get.back,
          child: EPadding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18.w,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          'Profile',
          style: TS.titleMedium.copyWith(color: Colors.white),
        ),
        actions: [
          InkWell(
            onTap: () => Get.to(() => const ComingSoonScreen()),
            child: EPadding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.edit,
                size: 18.w,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? _buildLoadingView()
            : _buildProfileView(),
      ),
    );
  }

  Widget _buildLoadingView() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Positioned(
            top: -1,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              child: Image.asset(
                'assets/images/bg_profile.png',
                width: Get.width,
                height: .48.sh,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppbarSpacer(),
              20.verticalSpace,
              _buildShimmerProfileImage(),
              5.verticalSpace,
              const Center(
                child: Column(
                  children: [
                    ShimmerText(width: 100),
                    ShimmerText(width: 50),
                    ShimmerText(width: 150),
                  ],
                ),
              ),
              20.verticalSpace,
              SizedBox(
                width: Get.width,
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const ShimmerText(width: 30),
                            10.verticalSpace,
                            const ShimmerText(width: 50),
                          ],
                        ),
                      ),
                      const VerticalDivider(color: Colors.black),
                      Expanded(
                        child: Column(
                          children: [
                            const ShimmerText(width: 30),
                            10.verticalSpace,
                            const ShimmerText(width: 50),
                          ],
                        ),
                      ),
                      VerticalDivider(color: Colors.black.withOpacity(0.8)),
                      Expanded(
                        child: Column(
                          children: [
                            const ShimmerText(width: 30),
                            10.verticalSpace,
                            const ShimmerText(width: 50),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              40.verticalSpace,
              EPadding(
                padding: const EdgeInsets.symmetric(horizontal: 21),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _titleMyInfo(),
                    _buildShimmerInfoRow(50),
                    _buildShimmerInfoRow(50),
                    _buildShimmerInfoRow(50),
                    _buildShimmerInfoRow(50),
                    _buildShimmerInfoRow(50),
                  ],
                ),
              ),
              20.verticalSpace,
              Container(
                color: grey,
                height: 5.h,
                width: Get.width,
              ),
              EPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    ItemMenuSettings(
                      assetSvg: 'assets/icons/ic_change_password.svg',
                      text: 'Change Password',
                      withTrailing: true,
                      onTap: () => Get.to(() => const ComingSoonScreen()),
                    ),
                    ItemMenuSettings(
                      assetSvg: 'assets/icons/ic_download_doc.svg',
                      text: 'Download Slip Gaji',
                      withTrailing: true,
                      onTap: () => Get.to(() => const ComingSoonScreen()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Positioned(
            top: -1,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              child: Image.asset(
                'assets/images/bg_profile.png',
                width: Get.width,
                height: 360.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppbarSpacer(),
              10.verticalSpace,
              Center(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(90),
                  ),
                  child: Image.asset(
                    'assets/images/img_profile.png',
                    height: 100.h,
                    width: 100.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              5.verticalSpace,
              Center(
                child: Column(
                  children: [
                    Text(
                      controller.profileData().fullName.isNotEmpty
                          ? controller.profileData().fullName
                          : '-',
                      style: TS.titleMedium.copyWith(color: white),
                    ),
                    Text(
                      controller.profileData().position.isNotEmpty
                          ? controller.profileData().position
                          : '-',
                      style: TS.labelLarge.copyWith(color: white),
                    ),
                    Text(
                      controller.profileData().company.isNotEmpty
                          ? controller.profileData().company
                          : '-',
                      style: TS.labelLarge.copyWith(color: white),
                    ),
                  ],
                ),
              ),
              20.verticalSpace,
              SizedBox(
                width: Get.width,
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildInfoColumn('Permit', '0'),
                      ),
                      const VerticalDivider(color: Colors.black),
                      Expanded(
                        child: _buildInfoColumn(
                          'Leave',
                          controller
                                  .profileData()
                                  .remainingLeave
                                  .toString()
                                  .isNotEmpty
                              ? controller
                                  .profileData()
                                  .remainingLeave
                                  .toString()
                              : '0',
                        ),
                      ),
                      VerticalDivider(
                        color: Colors.black.withOpacity(0.8),
                      ),
                      Expanded(
                        child: _buildInfoColumn('Work Period', '0'),
                      )
                    ],
                  ),
                ),
              ),
              35.verticalSpace,
              EPadding(
                padding: const EdgeInsets.symmetric(horizontal: 21),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    5.verticalSpace,
                    _titleMyInfo(),
                    _buildInfoRow(
                        Icons.email_outlined,
                        controller.profileData().email.isNotEmpty
                            ? controller.profileData().email
                            : '-'),
                    _buildInfoRow(
                      Icons.cake_outlined,
                      controller.profileData().birthdate.toString().isNotEmpty
                          ? controller.profileData().birthdate.toString()
                          : '-',
                    ),
                    _buildInfoRow(
                      Icons.person_outline,
                      controller.profileData().gender.isNotEmpty
                          ? controller.profileData().gender
                          : '-',
                    ),
                    _buildInfoRow(
                      SvgPicture.asset(
                        'assets/icons/ic_instagram.svg',
                        height: 20.h,
                      ),
                      controller.profileData().instagram.isNotEmpty
                          ? controller.profileData().instagram
                          : '-',
                    ),
                    _buildInfoRow(
                      SvgPicture.asset(
                        'assets/icons/ic_linkedin.svg',
                        height: 20.h,
                      ),
                      'https://www.linkedin.com/example.username',
                      color: Colors.blue[800],
                    ),
                  ],
                ),
              ),
              20.verticalSpace,
              Container(
                color: grey,
                height: 5.h,
                width: Get.width,
              ),
              EPadding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    ItemMenuSettings(
                      assetSvg: 'assets/icons/ic_change_password.svg',
                      text: 'Change Password',
                      withTrailing: true,
                      onTap: () => Get.to(() => const ComingSoonScreen()),
                    ),
                    ItemMenuSettings(
                      assetSvg: 'assets/icons/ic_download_doc.svg',
                      text: 'Download Slip Gaji',
                      withTrailing: true,
                      onTap: () => Get.to(() => const ComingSoonScreen()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerProfileImage() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Center(
        child: SizedBox(
          height: 100.h,
          width: 100.w,
          child: const CircleAvatar(),
        ),
      ),
    );
  }

  Widget _buildShimmerInfoRow(double width) {
    return EPadding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const ShimmerText(width: 50),
          12.horizontalSpace,
          Expanded(
            child: ShimmerText(width: width),
          ),
        ],
      ),
    );
  }

  Widget _titleMyInfo() {
    return Column(
      children: [
        Text(
          'My Information',
          style: TS.bodyLarge.copyWith(
            fontSize: 18.dm,
            fontWeight: FontWeight.w600,
          ),
        ),
        10.verticalSpace,
      ],
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TS.headlineSmall.copyWith(color: white),
        ),
        4.verticalSpace,
        Text(
          title,
          style: TS.labelLarge.copyWith(color: white),
        )
      ],
    );
  }

  Widget _buildInfoRow(dynamic icon, String text, {Color? color}) {
    if (text.isNotEmpty && icon is IconData) {
      if (icon == Icons.cake_outlined) {
        final birthdate = DateTime.parse(text);
        final formattedBirthdate =
            DateFormat('dd, MMMM yyyy').format(birthdate);
        text = formattedBirthdate;
      }
    }
    return EPadding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (icon is IconData) Icon(icon, color: color),
          if (icon is Widget) icon,
          12.horizontalSpace,
          Expanded(
            child: Text(
              text,
              style: TS.labelLarge.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}
