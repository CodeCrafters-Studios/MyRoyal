import 'package:flutter/widgets.dart';
import 'package:MyRoyal/app/modules/profile/presentation/controllers/profile_controller.dart';
import 'package:MyRoyal/app/modules/profile/presentation/views/components/shared/profile_information.dart';
import 'package:MyRoyal/base/widgets/padding.dart';

class TabProfessionalView extends StatelessWidget {
  const TabProfessionalView({super.key, required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 14),
        child: Column(
          children: [
            ProfileInformation(
              label: 'Nomor KTP',
              value:
                  controller.profileData().data.professional.idCard.isNotEmpty
                      ? controller.profileData().data.professional.idCard
                      : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Nomor Pegawai',
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
              label: 'Sisa Cuti',
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
              label: 'Posisi Jabatan',
              value:
                  controller.profileData().data.professional.position.isNotEmpty
                      ? controller.profileData().data.professional.position
                      : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Departemen',
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
              label: 'Tanggal Gabung',
              value:
                  controller.profileData().data.professional.joinDate.isNotEmpty
                      ? controller.profileData().data.professional.joinDate
                      : '-',
              controller: controller,
            ),
            ProfileInformation(
              label: 'Laporan Kepada',
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
