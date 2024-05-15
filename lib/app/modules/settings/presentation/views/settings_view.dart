import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/settings/presentation/views/components/item_menu_settings.dart';
import 'package:iroyal/app/modules/settings/presentation/views/components/switch_menu_settings.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/others/coming_soon.dart';
import 'package:iroyal/base/widgets/padding.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SettingsViewImpl(controller: controller),
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
        _buildSettingsHeader(),
        Expanded(
          child: ListView(
            padding: REdgeInsets.symmetric(horizontal: 21, vertical: 10),
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

  Widget _buildSettingsHeader() {
    return Center(
      child: EPadding(
        padding: const EdgeInsets.only(top: 50, bottom: 20),
        child: Text(
          'Settings',
          style: TS.headlineSmall,
        ),
      ),
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
          onTap: () => Get.to(
            () => const ComingSoonScreen(),
          ),
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
          () => controller.biometricsStatus.value
              ? SwitchMenuSettings(
                  assetSvg: 'assets/icons/ic_fingerprint.svg',
                  text: 'Fingerprint Login',
                  value: controller.biometricsValue.value,
                  onChanged: (value) => controller.iBiometrics(value),
                )
              : const SizedBox(),
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
