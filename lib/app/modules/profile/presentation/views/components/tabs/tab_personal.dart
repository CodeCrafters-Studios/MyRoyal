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
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 14),
        child: Obx(
          () => Column(
            children: [
              ProfileInformation(
                label: 'Full Name',
                value:
                    controller.profileData().data.personal.fullName.isNotEmpty
                        ? controller.profileData().data.personal.fullName
                        : '',
                controller: controller,
              ),
              ProfileInformation(
                label: 'First Name',
                value:
                    controller.profileData().data.personal.firstName.isNotEmpty
                        ? controller.profileData().data.personal.firstName
                        : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'Last Name',
                value:
                    controller.profileData().data.personal.lastName.isNotEmpty
                        ? controller.profileData().data.personal.lastName
                        : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'Nickname',
                value:
                    controller.profileData().data.personal.nickname.isNotEmpty
                        ? controller.profileData().data.personal.nickname
                        : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'Birthdate',
                value: controller
                        .profileData()
                        .data
                        .personal
                        .birthdate
                        .toString()
                        .isNotEmpty
                    ? DateFormat('dd, MMMM y').format(
                        controller.profileData().data.personal.birthdate)
                    : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'Birthplace',
                value:
                    controller.profileData().data.personal.birthplace.isNotEmpty
                        ? controller.profileData().data.personal.birthplace
                        : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'Gender',
                value: controller.profileData().data.personal.gender.isNotEmpty
                    ? controller.profileData().data.personal.gender
                    : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'Status',
                value: controller
                        .profileData()
                        .data
                        .personal
                        .maritalStatus
                        .isNotEmpty
                    ? controller.profileData().data.personal.maritalStatus
                    : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'No NPWP',
                value: controller.profileData().data.personal.npwp.isNotEmpty
                    ? controller.profileData().data.personal.npwp
                    : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'NPWP Status',
                value:
                    controller.profileData().data.personal.npwpStatus.isNotEmpty
                        ? controller.profileData().data.personal.npwpStatus
                        : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'Email Address',
                value: controller
                        .profileData()
                        .data
                        .personal
                        .personalEmail
                        .isNotEmpty
                    ? controller.profileData().data.personal.personalEmail
                    : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'Instagram',
                value:
                    controller.profileData().data.personal.instagram.isNotEmpty
                        ? controller.profileData().data.personal.instagram
                        : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'LinkedIn',
                value:
                    controller.profileData().data.personal.linkedin.isNotEmpty
                        ? controller.profileData().data.personal.linkedin
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
