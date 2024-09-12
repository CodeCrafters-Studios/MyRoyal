import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/app/modules/settings/presentation/views/components/item_menu_settings.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/app_divider.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/padding.dart';

class AttachmentsView extends StatelessWidget {
  const AttachmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.verticalSpace,
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
                    border: Border.all(color: primary),
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
                    border: Border.all(color: primary),
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
                    border: Border.all(color: primary),
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
                    border: Border.all(color: primary),
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
                    border: Border.all(color: primary),
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
              height: 400.h,
              child: ListView.separated(
                padding: REdgeInsets.only(bottom: 10.h),
                separatorBuilder: (_, __) => 15.verticalSpace,
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
      ),
    );
  }
}
