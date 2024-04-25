import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iroyal/app/modules/profile/views/components/item_menu_profile.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/page_base.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return PageBase(
      title: 'Profile',
      showBackgroundLogin: false,
      child: Column(
        children: [
          const AppbarSpacer(),
          CardApp(
            padding: REdgeInsets.all(16),
            margin: REdgeInsets.only(bottom: 16),
            isShadow: true,
            shadows: Shadows.small,
            radius: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('information'.tr, style: TS.titleMedium),
                16.verticalSpace,
                ItemMenuProfile(
                  assetSvg: 'assets/icons/ic_log_out.svg',
                  text: 'logout'.tr,
                  onTap: controller.cLogout,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
