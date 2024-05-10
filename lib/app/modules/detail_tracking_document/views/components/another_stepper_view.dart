import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/padding.dart';

class AnotherStepperView extends StatefulWidget {
  const AnotherStepperView({super.key});

  @override
  State<AnotherStepperView> createState() => _MyAppState();
}

class _MyAppState extends State<AnotherStepperView> {
  List<StepperData> stepperData = [
    StepperData(
      title: StepperText(
        "Norma Purnama",
      ),
      subtitle: StepperText(
        "REQUESTED",
        textStyle: const TextStyle(color: Colors.brown),
      ),
      iconWidget: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: const Center(
          child: Text(
            'NP',
            style: TextStyle(color: white),
          ),
        ),
      ),
    ),
    StepperData(
      title: StepperText("Daniel Wallington"),
      subtitle: StepperText(
        "APPROVED",
        textStyle: const TextStyle(color: primary),
      ),
      iconWidget: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: const Center(
          child: Text(
            'DW',
            style: TextStyle(color: white),
          ),
        ),
      ),
    ),
    StepperData(
      title: StepperText("Kitty Sarah"),
      iconWidget: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: const Center(
          child: Text(
            'KS',
            style: TextStyle(color: white),
          ),
        ),
      ),
    ),
    StepperData(
      title: StepperText(
        "Done",
        textStyle: const TextStyle(color: Colors.blue),
      ),
      iconWidget: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.blue,
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
      body: SingleChildScrollView(
        child: SizedBox(
          height: Get.height,
          child: Column(
            children: [
              EPadding(
                padding: const EdgeInsets.only(left: 20),
                child: AnotherStepper(
                  stepperList: stepperData,
                  stepperDirection: Axis.vertical,
                  iconWidth: 40,
                  iconHeight: 40,
                  activeBarColor: Colors.grey,
                  inActiveBarColor: Colors.grey,
                  verticalGap: 30,
                  activeIndex: 1,
                  barThickness: 1,
                ),
              ),
            ],
          ),
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
