import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/settings/presentation/views/components/item_menu_settings.dart';
import 'package:iroyal/app/modules/settings/presentation/views/components/switch_menu_settings.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/page_base.dart';

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
      textStyle: TS.headlineSmall,
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
        ItemMenuSettings(
          assetSvg: 'assets/icons/ic_change_password.svg',
          text: 'Change Password',
          withTrailing: true,
          onTap: () => Get.toNamed(Routes.HELP_AND_SUPPORT),
        ),
        ItemMenuSettings(
          assetSvg: 'assets/icons/ic_change_pin.svg',
          text: 'Change PIN',
          withTrailing: true,
          onTap: () => Get.toNamed(Routes.HELP_AND_SUPPORT),
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
        ),
      ],
    );
  }
}
