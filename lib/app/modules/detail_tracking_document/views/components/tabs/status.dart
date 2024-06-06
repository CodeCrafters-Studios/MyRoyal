import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/detail_tracking_document/controllers/detail_tracking_document_controller.dart';
import 'package:iroyal/app/modules/detail_tracking_document/views/components/bottom_sheet_button.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/padding.dart';

class StatusView extends StatefulWidget {
  const StatusView({super.key, required this.controller});

  final DetailTrackingDocumentController controller;

  @override
  State<StatusView> createState() => _MyAppState();
}

class _MyAppState extends State<StatusView> {
  List<StepperData> stepperData = [
    StepperData(
      title: StepperText(
        "Norma Purnama",
        textStyle: TS.titleSmall,
      ),
      subtitle: StepperText(
        "REQUESTED",
        textStyle: TS.bodySmall.copyWith(
          color: Colors.brown,
        ),
      ),
      iconWidget: Container(
        padding: REdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Center(
          child: Text(
            'NP',
            style: TS.labelMedium.copyWith(
              color: white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    ),
    StepperData(
      title: StepperText(
        "Daniel Wallington",
        textStyle: TS.titleSmall,
      ),
      subtitle: StepperText(
        "APPROVED",
        textStyle: TS.bodySmall.copyWith(
          color: green,
        ),
      ),
      iconWidget: Container(
        padding: REdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Center(
          child: Text(
            'DW',
            style: TS.labelMedium.copyWith(
              color: white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    ),
    StepperData(
      title: StepperText(
        "Kitty Sarah",
        textStyle: TS.titleSmall.copyWith(
          color: greyText,
        ),
      ),
      subtitle: StepperText(
        "WAITING FOR APPROVAL",
        textStyle: TS.bodySmall.copyWith(
          color: greyText,
        ),
      ),
      iconWidget: Container(
        padding: REdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: Center(
          child: Text(
            'KS',
            style: TS.labelMedium.copyWith(
              color: white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    ),
    StepperData(
      title: StepperText(
        "Done",
        textStyle: TS.titleSmall.copyWith(
          color: greyText,
        ),
      ),
      iconWidget: Container(
        padding: REdgeInsets.all(6),
        decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.flag,
            color: white,
          ),
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

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
                stepperList: stepperData,
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
