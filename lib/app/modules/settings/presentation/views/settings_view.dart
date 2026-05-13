import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/settings/presentation/views/components/item_menu_settings.dart';
import 'package:MyRoyal/app/modules/settings/presentation/views/components/switch_menu_settings.dart';
import 'package:MyRoyal/app/routes/app_pages.dart';
import 'package:MyRoyal/base/config/app_constants.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/others/coming_soon.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: white,
          appBar: AppBar(
            title: Text('Pengaturan',
                style: TS.headlineSmall.copyWith(color: white)),
            backgroundColor: primary,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: 70.h,
          ),
          body: SettingsViewImpl(controller: controller),
        ));
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
        10.verticalSpace,
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
          'Informasi Pribadi',
          style: TS.titleMedium,
        ),
        16.verticalSpace,
        ItemMenuSettings(
          assetSvg: 'assets/icons/ic_tab_profile.svg',
          text: 'Profil',
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
            text: 'Ubah kata sandi',
            withTrailing: true,
            onTap: () => Get.to(() => const ComingSoonScreen())
            // Get.toNamed(Routes.CHANGE_PASSWORD),
            ),
        ItemMenuSettings(
            assetSvg: 'assets/icons/ic_change_pin.svg',
            text: 'Ubah PIN',
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
          'Bantuan & Informasi',
          style: TS.titleMedium,
        ),
        16.verticalSpace,
        ItemMenuSettings(
          assetSvg: 'assets/icons/ic_help&support.svg',
          text: 'Bantuan & Dukungan',
          withTrailing: true,
          onTap: () => Get.toNamed(Routes.HELP_AND_SUPPORT),
        ),
        ItemMenuSettings(
          assetSvg: 'assets/icons/ic_terms&polcies.svg',
          text: 'Syarat & Ketentuan',
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
          'Aksi',
          style: TS.titleMedium,
        ),
        16.verticalSpace,
        Obx(
          () => controller.getAvailableBiometrics.value
              ? SwitchMenuSettings(
                  assetSvg: 'assets/icons/ic_fingerprint.svg',
                  text: 'Masuk dengan sidik jari',
                  value: controller.switchbiometricsValue.value,
                  onChanged: (value) => controller.iBiometrics(value),
                )
              : emptyBox,
        ),
        80.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: red,
          ),
          child: ItemMenuSettings(
            assetSvg: 'assets/icons/ic_log_out.svg',
            iconColor: white,
            text: 'Keluar',
            textStyle: TS.labelLarge.copyWith(
              color: white,
            ),
            textStyleTrailing: TS.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
              color: white,
            ),
            onTap: controller.logout,
            withTrailing: true,
            withDivider: false,
            trailingIcon: false,
            appVersion: controller.deviceInfo.packageInfo.version,
          ),
        ),
      ],
    );
  }
}
