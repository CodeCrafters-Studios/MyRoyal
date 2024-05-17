import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/padding.dart';

class StatusView extends StatefulWidget {
  const StatusView({super.key});

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
        padding: const EdgeInsets.all(6),
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
        padding: const EdgeInsets.all(6),
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
        padding: const EdgeInsets.all(6),
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
        padding: const EdgeInsets.all(6),
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
              padding: const EdgeInsets.only(left: 20),
              child: AnotherStepper(
                scrollPhysics: const NeverScrollableScrollPhysics(),
                stepperList: stepperData,
                stepperDirection: Axis.vertical,
                iconWidth: 40,
                iconHeight: 40,
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
      bottomSheet: Container(
        padding: EdgeInsets.only(bottom: 10.h, top: 20.h),
        height: 100.h,
        width: Get.width,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: grey, width: 2.0),
          ),
          color: white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 48.h,
              width: 180.w,
              child: ButtonPrimary(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                onPressed: () {},
                key: const Key('rejectBtn'),
                suffixIcon: const Icon(
                  Icons.close,
                  color: white,
                ),
                text: 'Reject',
                color: Colors.red,
              ),
            ),
            SizedBox(
              height: 48.h,
              width: 180.w,
              child: ButtonPrimary(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                onPressed: () {},
                key: const Key('approveBtn'),
                suffixIcon: const Icon(
                  Icons.check,
                  color: white,
                ),
                text: 'Approve',
                color: green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
