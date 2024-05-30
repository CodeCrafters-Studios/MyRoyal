import 'package:flutter/widgets.dart';
import 'package:iroyal/app/modules/profile/presentation/controllers/profile_controller.dart';
import 'package:iroyal/app/modules/profile/presentation/views/components/shared/profile_information.dart';
import 'package:iroyal/base/widgets/padding.dart';

class TabProfessionalView extends StatelessWidget {
  const TabProfessionalView({super.key, required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            ProfileInformation(
              label: 'Employee ID',
              value: controller.jobData().employeeNumber.isNotEmpty
                  ? controller.jobData().employeeNumber
                  : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Email Address',
              value: controller.profileData().email.isNotEmpty
                  ? controller.profileData().email
                  : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Position',
              value: controller.profileData().position.isNotEmpty
                  ? controller.profileData().position
                  : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Departement',
              value: controller.profileData().department.isNotEmpty
                  ? controller.profileData().department
                  : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Company',
              value: controller.profileData().company.isNotEmpty
                  ? controller.profileData().company
                  : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Report to',
              value: controller.profileData().reportTo.isNotEmpty
                  ? controller.profileData().reportTo
                  : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Join Date',
              value: controller.jobData().joinDate.isNotEmpty
                  ? controller.jobData().joinDate
                  : '-',
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}
