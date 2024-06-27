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
              value: controller.profileData().personal.idCard.isNotEmpty
                  ? controller.profileData().personal.idCard
                  : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Employee ID',
              value: controller.userData().job.employeeNumber.isNotEmpty
                  ? controller.userData().job.employeeNumber
                  : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Remaining Leave',
              value: controller
                  .profileData()
                  .professional
                  .remainingLeave
                  .toString(),
              controller: controller,
            ),
            ProfileInformation(
              label: 'BPJS Kesehatan',
              value: controller
                  .profileData()
                  .professional
                  .bpjsKesehatan
                  .toString(),
              controller: controller,
            ),
            ProfileInformation(
              label: 'BPJS Ketenagakerjaan',
              value: controller
                  .profileData()
                  .professional
                  .bpjsTenagakerja
                  .toString(),
              controller: controller,
            ),
            ProfileInformation(
              label: 'Email Address',
              value: controller.userData().job.workEmail.isNotEmpty
                  ? controller.userData().job.workEmail
                  : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Position',
              value: controller.profileData().professional.position.isNotEmpty
                  ? controller.profileData().professional.position
                  : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Departement',
              value: controller.profileData().professional.department.isNotEmpty
                  ? controller.profileData().professional.department
                  : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Company',
              value: controller.profileData().professional.company.isNotEmpty
                  ? controller.profileData().professional.company
                  : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Report to',
              value: controller.profileData().professional.reportTo.isNotEmpty
                  ? controller.profileData().professional.reportTo
                  : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Join Date',
              value: controller.userData().job.joinDate.isNotEmpty
                  ? controller.userData().job.joinDate
                  : '-',
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}
