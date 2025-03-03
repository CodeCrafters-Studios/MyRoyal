import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:lottie/lottie.dart';

class NoLeavesAvailable extends StatelessWidget {
  const NoLeavesAvailable({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 80.h),
      child: Column(
        children: [
          Text(
            "You don't have any leave request available",
            style: TS.labelLarge,
            textAlign: TextAlign.center,
          ),
          8.verticalSpace,
          Text(
            "Please go back,",
            style: TS.labelLarge,
            textAlign: TextAlign.center,
          ),
          Text(
            "but don't go back into your ex-crush",
            style: TS.labelLarge,
            textAlign: TextAlign.center,
          ),
          20.verticalSpace,
          Lottie.asset(
            width: 320.w,
            'assets/json/lottie_no_leaves_available.json',
          ),
        ],
      ),
    );
  }
}
