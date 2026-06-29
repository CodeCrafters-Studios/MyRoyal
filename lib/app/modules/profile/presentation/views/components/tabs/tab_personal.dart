import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:MyRoyal/app/modules/profile/presentation/controllers/profile_controller.dart';
import 'package:MyRoyal/app/modules/profile/presentation/views/components/shared/profile_information.dart';
import 'package:MyRoyal/base/widgets/padding.dart';

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
                label: 'Nama Depan',
                value:
                    controller.profileData().data.personal.firstName.isNotEmpty
                        ? controller.profileData().data.personal.firstName
                        : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'Nama Belakang',
                value:
                    controller.profileData().data.personal.lastName.isNotEmpty
                        ? controller.profileData().data.personal.lastName
                        : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'Nama Panggilan',
                value:
                    controller.profileData().data.personal.nickname.isNotEmpty
                        ? controller.profileData().data.personal.nickname
                        : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'Tanggal Lahir',
                value: controller
                        .profileData()
                        .data
                        .personal
                        .birthdate
                        .toString()
                        .isNotEmpty
                    ? DateFormat('dd MMMM y').format(
                        controller.profileData().data.personal.birthdate)
                    : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'Tempat Lahir',
                value:
                    controller.profileData().data.personal.birthplace.isNotEmpty
                        ? controller.profileData().data.personal.birthplace
                        : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'Jenis Kelamin',
                value: controller.profileData().data.personal.gender.isNotEmpty
                    ? controller.profileData().data.personal.gender
                    : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'Status Pernikahan',
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
                label: 'StatusNPWP',
                value:
                    controller.profileData().data.personal.npwpStatus.isNotEmpty
                        ? controller.profileData().data.personal.npwpStatus
                        : '-',
                controller: controller,
              ),
              ProfileInformation(
                label: 'Alamat Email',
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
