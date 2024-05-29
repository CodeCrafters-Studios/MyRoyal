import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iroyal/app/modules/profile/presentation/controllers/profile_controller.dart';
import 'package:iroyal/app/modules/profile/presentation/views/components/shared/profile_information.dart';
import 'package:iroyal/base/widgets/padding.dart';

class TabPersonalView extends StatelessWidget {
  const TabPersonalView({super.key, required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Obx(
        () => Column(
          children: [
            ProfileInformation(
              label: 'Full Name',
              value: controller.profileData().fullName.isNotEmpty
                  ? controller.profileData().fullName
                  : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Birthdate',
              value: controller.profileData().birthdate.toString().isNotEmpty
                  ? DateFormat('dd, MMMM y')
                      .format(controller.profileData().birthdate)
                  : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Gender',
              value: controller.profileData().gender.isNotEmpty
                  ? controller.profileData().gender
                  : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Status',
              value: controller.status.value.isNotEmpty
                  ? controller.status.value
                  : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Instagram',
              value: controller.profileData().instagram.isNotEmpty
                  ? controller.profileData().instagram
                  : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'LinkedIn',
              value: controller.profileData().linkedin.isNotEmpty
                  ? controller.profileData().linkedin
                  : '-',
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}
