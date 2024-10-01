import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/profile/presentation/controllers/profile_controller.dart';
import 'package:iroyal/app/modules/profile/presentation/views/components/file_view.dart';
import 'package:iroyal/app/modules/profile/presentation/views/components/pdf_view.dart';
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
        child: SizedBox(
          height: Get.height,
          child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: controller.profileData().data.documents.length,
              itemBuilder: (context, index) {
                final data = controller.profileData().data.documents[index];
                return ItemMenuSettings(
                  assetSvg: 'assets/icons/ic_download_doc.svg',
                  text: data.type.capitalize.toString(),
                  textStyle: TS.bodyMedium,
                  icon: Icons.download,
                  withTrailing: true,
                  onTap: () => data.ext == '.jpeg'
                      ? Get.to(() => FileView(title: data.name, url: data.url))
                      : Get.to(() => PDFView(
                            title: data.name,
                            url: data.url,
                          )),
                  onTapIcon: () => controller.downloadPdf(data.url, data.name),
                );
              }),
        ),
      ),
    );
  }
}
