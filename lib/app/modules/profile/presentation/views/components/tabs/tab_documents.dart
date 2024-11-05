import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/profile/presentation/controllers/profile_controller.dart';
import 'package:iroyal/app/modules/profile/presentation/views/components/file_view.dart';
import 'package:iroyal/app/modules/profile/presentation/views/components/pdf_view.dart';
import 'package:iroyal/app/modules/settings/presentation/views/components/item_menu_settings.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:lottie/lottie.dart';

class TabDocumentsView extends StatelessWidget {
  const TabDocumentsView({super.key, required this.controller});

  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Obx(
      () => controller.profileData().data.documents.isNotEmpty
          ? EPadding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: SizedBox(
                height: Get.height,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller.profileData().data.documents.length,
                    itemBuilder: (context, index) {
                      final data =
                          controller.profileData().data.documents[index];
                      return ItemMenuSettings(
                        assetSvg: 'assets/icons/ic_download_doc.svg',
                        text: data.type.capitalize.toString(),
                        textStyle: TS.bodyMedium,
                        icon: Icons.download,
                        withTrailing: true,
                        onTap: () => data.ext == '.pdf'
                            ? Get.to(() => PDFView(
                                  title: data.name,
                                  url: data.url,
                                ))
                            : Get.to(() => FileView(
                                  title: data.name,
                                  url: data.url,
                                )),
                        onTapIcon: () =>
                            controller.downloadFiles(data.url, data.name),
                      );
                    }),
              ),
            )
          : SizedBox(
              height: Get.height / 1.5, child: const NoDocumentFoundWidget()),
    ));
  }
}

class NoDocumentFoundWidget extends StatelessWidget {
  const NoDocumentFoundWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
          'assets/json/lottie_empyt_box.json',
        ),
        Text("We'are sorry, we didn't found the page you need.",
            style: TS.bodyMini.copyWith(fontSize: 12)),
        8.verticalSpace,
        Text(
          "Please go back,\nbut please don't go back to your ex-crush",
          style: TS.labelSmall,
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
