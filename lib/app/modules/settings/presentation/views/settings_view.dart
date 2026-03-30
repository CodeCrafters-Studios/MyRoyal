import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/settings/presentation/views/components/item_menu_settings.dart';
import 'package:MyRoyal/app/modules/settings/presentation/views/components/switch_menu_settings.dart';
import 'package:MyRoyal/app/routes/app_pages.dart';
import 'package:MyRoyal/base/config/app_constants.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/appbar_spacer.dart';
import 'package:MyRoyal/base/widgets/others/coming_soon.dart';
import 'package:MyRoyal/base/widgets/page_base.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      showIconBack: false,
      centeredTitle: true,
      title: 'Settings',
      textStyle: TS.headlineSmall.copyWith(color: white),
      child: SettingsViewImpl(controller: controller),
    );
  }
}

class SettingsViewImpl extends StatelessWidget {
  const SettingsViewImpl({
    super.key,
    required this.controller,
  });

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AppbarSpacer(),
        15.verticalSpace,
        Expanded(
          child: ListView(
            padding: REdgeInsets.symmetric(horizontal: 21),
            children: [
              _buildPersonalInformationSection(),
              10.verticalSpace,
              _buildSupportAndAboutSection(),
              10.verticalSpace,
              _buildActionsSection(),
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
        ItemMenuSettings(
          assetSvg: 'assets/icons/ic_tab_profile.svg',
          text: 'Profile',
          withTrailing: true,
          onTap: () {
            Get.toNamed(Routes.PROFILE);
          },
        ),
        // ItemMenuSettings(
        //   assetSvg: 'assets/icons/ic_my_assets_settings.svg',
        //   text: 'My Assets',
        //   withTrailing: true,
        //   onTap: () {
        //     Get.toNamed(Routes.MY_ASSETS);
        //   },
        // ),
        ItemMenuSettings(
            assetSvg: 'assets/icons/ic_change_password.svg',
            text: 'Change Password',
            withTrailing: true,
            onTap: () => Get.to(() => const ComingSoonScreen())
            // Get.toNamed(Routes.CHANGE_PASSWORD),
            ),
        ItemMenuSettings(
            assetSvg: 'assets/icons/ic_change_pin.svg',
            text: 'Change PIN',
            withTrailing: true,
            onTap: () => Get.to(() => const ComingSoonScreen())
            // Get.toNamed(Routes.CHANGE_PIN),
            ),
      ],
    );
  }

  Widget _buildSupportAndAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Support & About',
          style: TS.titleMedium,
        ),
        16.verticalSpace,
        ItemMenuSettings(
          assetSvg: 'assets/icons/ic_help&support.svg',
          text: 'Help & Support',
          withTrailing: true,
          onTap: () => Get.toNamed(Routes.HELP_AND_SUPPORT),
        ),
        ItemMenuSettings(
          assetSvg: 'assets/icons/ic_terms&polcies.svg',
          text: 'Terms & Policies',
          withTrailing: true,
          onTap: () => Get.toNamed(Routes.TERMS_AND_POLICIES),
        ),
      ],
    );
  }

  Widget _buildActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions',
          style: TS.titleMedium,
        ),
        16.verticalSpace,
        Obx(
          () => controller.getAvailableBiometrics.value
              ? SwitchMenuSettings(
                  assetSvg: 'assets/icons/ic_fingerprint.svg',
                  text: 'Fingerprint Login',
                  value: controller.switchbiometricsValue.value,
                  onChanged: (value) => controller.iBiometrics(value),
                )
              : emptyBox,
        ),
        ItemMenuSettings(
          assetSvg: 'assets/icons/ic_log_out.svg',
          text: 'Logout',
          onTap: controller.iLogout,
          withTrailing: true,
          trailingIcon: false,
          appVersion: controller.deviceInfo.packageInfo.version,
        ),
      ],
    );
  }
}
