import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:iroyal/app/modules/profile/views/components/item_menu_profile.dart';
import 'package:iroyal/app/modules/profile/views/components/switch_menu_profile.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:shimmer/shimmer.dart';

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
                () => controller.isLoading.value == true
                    ? Shimmer.fromColors(
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
                                    padding: REdgeInsets.only(
                                      left: 8,
                                      top: 5,
                                      bottom: 8,
                                    ),
                                    margin: REdgeInsets.only(top: 5),
                                    width: 80,
                                  ),
                                  ShimmerText(
                                    padding: REdgeInsets.only(
                                      left: 8,
                                      top: 5,
                                      bottom: 8,
                                    ),
                                    margin: REdgeInsets.only(top: 5),
                                    width: 120,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(
                              controller
                                      .userData()
                                      .employee
                                      .firstName
                                      .isNotEmpty
                                  ? controller.getImageName()
                                  : '',
                              style:
                                  TS.titleMedium.copyWith(color: primaryColor),
                            ),
                          ),
                          12.horizontalSpace,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${controller.userData().employee.firstName.toUpperCase()} ${controller.userData().employee.lastName.toUpperCase()}",
                                  style: TS.labelLarge
                                      .copyWith(color: Colors.white),
                                ),
                                Text(
                                  controller.userData().job.company,
                                  style: TS.bodyMedium
                                      .copyWith(color: Colors.white),
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
                      value: controller.bioValue.value == true ? true : false,
                      onChanged: (value) {
                        controller.iBiometrics(value);
                      },
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
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
                    text: 'Logout',
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
