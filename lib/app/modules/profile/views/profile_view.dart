import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:iroyal/app/modules/profile/views/components/item_menu_profile.dart';
import 'package:iroyal/app/modules/profile/views/components/switch_menu_profile.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileViewImpl(controller: controller),
    );
  }
}

class ProfileViewImpl extends StatelessWidget {
  const ProfileViewImpl({
    super.key,
    required this.controller,
  });

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildProfileHeader(),
        Expanded(
          child: ListView(
            padding: REdgeInsets.symmetric(horizontal: 21, vertical: 10),
            children: [
              _buildPersonalInformationSection(),
              10.verticalSpace,
              _buildInformationSection(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          child: Image.asset(
            'assets/images/bg_profile.png',
            width: Get.width,
            height: .15.sh,
            fit: BoxFit.cover,
          ),
        ),
        EPadding(
          padding: const EdgeInsets.all(16),
          child: Obx(
            () => controller.isLoading.value
                ? _buildLoadingProfile()
                : _buildLoadedProfile(),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingProfile() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Row(
        children: [
          const CircleAvatar(),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerText(
                  padding: REdgeInsets.only(left: 8, top: 5, bottom: 8),
                  margin: REdgeInsets.only(top: 5),
                  width: 80.w,
                ),
                ShimmerText(
                  padding: REdgeInsets.only(left: 8, top: 5, bottom: 8),
                  margin: REdgeInsets.only(top: 5),
                  width: 120.w,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedProfile() {
    final userData = controller.userData();
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: white,
          child: Text(
            userData.employee.firstName.isNotEmpty
                ? controller.getImageName()
                : '',
            style: TS.titleMedium.copyWith(color: primaryColor),
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${userData.employee.firstName.toUpperCase()} ${userData.employee.lastName.toUpperCase()}',
                style: TS.labelLarge.copyWith(color: white),
              ),
              Text(
                userData.job.company,
                style: TS.bodyMedium.copyWith(color: white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: TS.titleMedium,
        ),
        16.verticalSpace,
        ItemMenuProfile(
          assetSvg: 'assets/icons/ic_tab_profile.svg',
          text: 'Profile',
          withTrailing: true,
          onTap: () {},
        ),
        Obx(
          () => SwitchMenuProfile(
            assetSvg: 'assets/icons/ic_fingerprint.svg',
            text: 'Fingerprint Login',
            value: controller.biometricsValue.value,
            onChanged: (value) => controller.iBiometrics(value),
          ),
        ),
      ],
    );
  }

  Widget _buildInformationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Information',
          style: TS.titleMedium,
        ),
        16.verticalSpace,
        ItemMenuProfile(
          assetSvg: 'assets/icons/ic_log_out.svg',
          text: 'Logout',
          onTap: controller.iLogout,
        ),
      ],
    );
  }
}
