import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';

class HeaderView extends StatelessWidget {
  const HeaderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          width: Get.width,
          height: Get.height,
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.only(right: 150),
                title: Text(
                  'Due Date: ',
                  style: TS.labelLarge.copyWith(
                    color: black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: SizedBox(
                  // Wrap the trailing widget with SizedBox
                  width: 150, // Adjust width as needed
                  child: Text(
                    '25.11.2024',
                    style: TS.labelLarge.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'PR Header Note: ',
                  style: TS.labelLarge.copyWith(
                    color: black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: SizedBox(
                  width: 300,
                  child: Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                    style: TS.labelLarge.copyWith(fontWeight: FontWeight.w600),
                  ),
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
