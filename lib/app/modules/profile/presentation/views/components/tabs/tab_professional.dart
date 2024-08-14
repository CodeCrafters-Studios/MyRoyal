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
              label: 'ID Card',
              value:
                  controller.profileData().data.professional.idCard.isNotEmpty
                      ? controller.profileData().data.professional.idCard
                      : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Employee ID',
              value: controller
                      .profileData()
                      .data
                      .professional
                      .employeeNumber
                      .isNotEmpty
                  ? controller.profileData().data.professional.employeeNumber
                  : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Remaining Leave',
              value: controller
                  .profileData()
                  .data
                  .professional
                  .reaminingLeave
                  .toString(),
              controller: controller,
            ),
            ProfileInformation(
              label: 'BPJS Kesehatan',
              value: controller
                  .profileData()
                  .data
                  .professional
                  .bpjsKesehatan
                  .toString(),
              controller: controller,
            ),
            ProfileInformation(
              label: 'BPJS Ketenagakerjaan',
              value: controller
                  .profileData()
                  .data
                  .professional
                  .bpjsKetenagakerjaan
                  .toString(),
              controller: controller,
            ),
            ProfileInformation(
              label: 'Email Address',
              value: controller
                      .profileData()
                      .data
                      .professional
                      .workEmail
                      .isNotEmpty
                  ? controller.profileData().data.professional.workEmail
                  : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Position',
              value:
                  controller.profileData().data.professional.position.isNotEmpty
                      ? controller.profileData().data.professional.position
                      : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Departement',
              value: controller
                      .profileData()
                      .data
                      .professional
                      .department
                      .isNotEmpty
                  ? controller.profileData().data.professional.department
                  : '-',
              controller: controller,
            ),
            // ProfileInformation(
            //   label: 'Company',
            //   value: controller.profileData().data.professional.company.isNotEmpty
            //       ? controller.profileData().professional.company
            //       : '-',
            //   controller: controller,
            // ),
            ProfileInformation(
              label: 'Join Date',
              value:
                  controller.profileData().data.professional.joinDate.isNotEmpty
                      ? controller.profileData().data.professional.joinDate
                      : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Report to',
              value:
                  controller.profileData().data.professional.reportTo.isNotEmpty
                      ? controller.profileData().data.professional.reportTo
                      : '-',
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}
