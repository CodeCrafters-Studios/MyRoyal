import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iroyal/app/modules/profile/views/components/item_menu_profile.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return ProfileViewImpl(controller: controller);
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
        Stack(
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
            Padding(
              padding: REdgeInsets.all(16),
              child: Obx(
                () => Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        controller.userData().employee.firstName.isNotEmpty
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
                            "${controller.userData().employee.firstName} ${controller.userData().employee.lastName}",
                            style: TS.labelLarge.copyWith(color: Colors.white),
                          ),
                          Text(
                            controller.userData().email,
                            style: TS.bodyMedium.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView(
            padding: REdgeInsets.symmetric(horizontal: 21, vertical: 10),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Information',
                    style: TS.titleMedium,
                  ),
                  16.verticalSpace,
                  ItemMenuProfile(
                    assetSvg: 'assets/icons/ic_log_out.svg',
                    text: 'logout'.tr,
                    onTap: controller.iLogout,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
