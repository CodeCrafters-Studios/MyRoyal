import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/detail_tasks/controllers/detail_tasks_controller.dart';
import 'package:iroyal/app/modules/settings/presentation/views/components/item_menu_settings.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/app_divider.dart';
import 'package:iroyal/base/widgets/card_app.dart';

class AttachmentsTaskView extends StatelessWidget {
  const AttachmentsTaskView({
    super.key,
    required this.controller,
  });

  final DetailTasksController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Photos',
            style: TS.bodyLarge,
          ),
          const AppDivider(),
          10.verticalSpace,
          GridView.count(
            padding: EdgeInsets.zero,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            shrinkWrap: true,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: grey),
                  borderRadius: BorderRadius.all(
                    Radius.circular(14.r),
                  ),
                ),
                child: Image.asset(
                  'assets/images/img_file1.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: grey),
                  borderRadius: BorderRadius.all(
                    Radius.circular(14.r),
                  ),
                ),
                child: Image.asset(
                  'assets/images/img_file2.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: grey),
                  borderRadius: BorderRadius.all(
                    Radius.circular(14.r),
                  ),
                ),
                child: Image.asset(
                  'assets/images/img_file3.jpg',
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: grey),
                  borderRadius: BorderRadius.all(
                    Radius.circular(14.r),
                  ),
                ),
                child: Image.asset(
                  'assets/images/img_file4.jpg',
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: grey),
                  borderRadius: BorderRadius.all(
                    Radius.circular(14.r),
                  ),
                ),
                child: Image.asset(
                  'assets/images/img_file5.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          20.verticalSpace,
          Text(
            'Documents',
            style: TS.bodyLarge,
          ),
          const AppDivider(),
          10.verticalSpace,
          SizedBox(
            height: Get.height,
            child: ListView.separated(
              separatorBuilder: (_, __) => 15.verticalSpace,
              padding: REdgeInsets.only(bottom: 530.h),
              itemCount: 10,
              itemBuilder: (_, __) {
                return CardApp(
                  padding: REdgeInsets.symmetric(horizontal: 12),
                  isOutlined: true,
                  borderWidth: 1,
                  outlineColor: grey50,
                  child: ItemMenuSettings(
                    assetSvg: 'assets/icons/ic_download_doc.svg',
                    text: 'Document Name',
                    textStyle: TS.bodyMedium,
                    icon: Icons.download,
                    withTrailing: true,
                    onTap: () {},
                    withDivider: false,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
