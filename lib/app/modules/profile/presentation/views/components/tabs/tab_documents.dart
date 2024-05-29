import 'package:flutter/material.dart';
import 'package:iroyal/app/modules/profile/presentation/controllers/profile_controller.dart';
import 'package:iroyal/app/modules/settings/presentation/views/components/item_menu_settings.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/padding.dart';

class TabDocumentsView extends StatelessWidget {
  const TabDocumentsView({super.key, required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            ItemMenuSettings(
              assetSvg: 'assets/icons/ic_download_doc.svg',
              text: 'Salary Slip',
              textStyle: TS.bodyMedium,
              icon: Icons.download,
              withTrailing: true,
              onTap: () {},
            ),
            ItemMenuSettings(
              assetSvg: 'assets/icons/ic_download_doc.svg',
              text: 'Offer Letter',
              textStyle: TS.bodyMedium,
              icon: Icons.download,
              withTrailing: true,
              onTap: () {},
            ),
            ItemMenuSettings(
              assetSvg: 'assets/icons/ic_download_doc.svg',
              text: 'Bond Agreement',
              textStyle: TS.bodyMedium,
              icon: Icons.download,
              withTrailing: true,
              onTap: () {},
            ),
            ItemMenuSettings(
              assetSvg: 'assets/icons/ic_download_doc.svg',
              text: 'Appraisal Letter',
              textStyle: TS.bodyMedium,
              icon: Icons.download,
              withTrailing: true,
              onTap: () {},
            ),
            ItemMenuSettings(
              assetSvg: 'assets/icons/ic_download_doc.svg',
              text: 'Appointment Letter',
              textStyle: TS.bodyMedium,
              icon: Icons.download,
              withTrailing: true,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
