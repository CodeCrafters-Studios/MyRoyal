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
    return SingleChildScrollView(
      child: EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Obx(
          () => Column(
            children: [
              ProfileInformation(
                label: 'Full Name',
                value: controller.profileData().personal.fullName.isNotEmpty
                    ? controller.profileData().personal.fullName
                    : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'Last Name',
                value: controller.profileData().personal.lastName.isNotEmpty
                    ? controller.profileData().personal.lastName
                    : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'Nickname',
                value: controller.profileData().personal.nickname.isNotEmpty
                    ? controller.profileData().personal.nickname
                    : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'Birthdate',
                value: controller
                        .profileData()
                        .personal
                        .birthdate
                        .toString()
                        .isNotEmpty
                    ? DateFormat('dd, MMMM y')
                        .format(controller.profileData().personal.birthdate)
                    : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'Birthplace',
                value: controller.profileData().personal.birthplace.isNotEmpty
                    ? controller.profileData().personal.birthplace
                    : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'Gender',
                value: controller.profileData().personal.gender.isNotEmpty
                    ? controller.profileData().personal.gender
                    : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'Status',
                value: controller.userData().employee.maritalStatus.isNotEmpty
                    ? controller.userData().employee.maritalStatus
                    : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'No NPWP',
                value: controller.profileData().personal.npwp.isNotEmpty
                    ? controller.profileData().personal.npwp
                    : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'NPWP Status',
                value: controller.profileData().personal.npwpStatus.isNotEmpty
                    ? controller.profileData().personal.npwpStatus
                    : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'Email Address',
                value:
                    controller.profileData().personal.personalEmail.isNotEmpty
                        ? controller.profileData().personal.personalEmail
                        : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'Instagram',
                value: controller.profileData().personal.instagram.isNotEmpty
                    ? controller.profileData().personal.instagram
                    : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'LinkedIn',
                value: controller.profileData().personal.linkedin.isNotEmpty
                    ? controller.profileData().personal.linkedin
                    : '-',
                controller: controller,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
