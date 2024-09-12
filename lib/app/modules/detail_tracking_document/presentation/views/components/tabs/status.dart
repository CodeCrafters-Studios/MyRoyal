import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/detail_tracking_document/presentation/controllers/detail_tracking_document_controller.dart';
import 'package:iroyal/app/modules/detail_tracking_document/presentation/views/components/bottom_sheet_button.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/widgets/padding.dart';

class StatusDocumentView extends StatelessWidget {
  const StatusDocumentView({super.key, required this.controller});

  final DetailTrackingDocumentController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SizedBox(
        height: Get.height,
        child: Column(
          children: [
            EPadding(
              padding: REdgeInsets.only(left: 20),
              child: AnotherStepper(
                scrollPhysics: const NeverScrollableScrollPhysics(),
                stepperList: controller.stepperData,
                stepperDirection: Axis.vertical,
                iconWidth: 40.w,
                iconHeight: 40.h,
                activeBarColor: Colors.grey,
                inActiveBarColor: Colors.grey,
                verticalGap: 35,
                activeIndex: 1,
                barThickness: 1,
              ),
            ),
          ],
        ),
      ),
      bottomSheet: const BottomSheetButton(),
    );
  }
}
