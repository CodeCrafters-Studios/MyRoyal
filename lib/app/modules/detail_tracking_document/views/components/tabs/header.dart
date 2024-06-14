import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/detail_tracking_document/views/components/bottom_sheet_button.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';

class HeaderDocumentView extends StatelessWidget {
  const HeaderDocumentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Container(
            padding: REdgeInsets.symmetric(horizontal: 18, vertical: 20),
            width: Get.width,
            height: Get.height,
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Due Date:',
                      style: TS.bodyMedium,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(
                      '25.11.2024',
                      style:
                          TS.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Posting Date:',
                      style: TS.bodyMedium,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(
                      '20.11.2024',
                      style:
                          TS.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      'FI No:',
                      style: TS.bodyMedium,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(
                      '33000004',
                      style:
                          TS.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Purchasing Group:',
                      style: TS.bodyMedium,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(
                      'PT Royal Abadi Sejahtera',
                      style:
                          TS.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Company:',
                      style: TS.bodyMedium,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(
                      'PT Royal Abadi Sejahtera',
                      style:
                          TS.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      'PR No:',
                      style: TS.bodyMedium,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(
                      '1055098506',
                      style:
                          TS.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      'PO No:',
                      style: TS.bodyMedium,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(
                      '8820211120',
                      style:
                          TS.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      'PR Header Note:',
                      style: TS.bodyMedium,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(
                      'Lorem ipsum dolor sit amet, consectetur',
                      style:
                          TS.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Vendor:',
                      style: TS.bodyMedium,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(
                      'Lorem ipsum dolor sit amet.',
                      style:
                          TS.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      'Tax Code:',
                      style: TS.bodyMedium,
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(
                      'D7',
                      style:
                          TS.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ])),
      ),
      bottomSheet: const BottomSheetButton(),
    );
  }
}
