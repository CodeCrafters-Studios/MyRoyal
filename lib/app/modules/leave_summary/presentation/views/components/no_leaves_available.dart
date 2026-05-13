import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:MyRoyal/base/design/styles.dart';
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
            "Tidak ada cuti yang tersedia",
            style: TS.labelLarge,
            textAlign: TextAlign.center,
          ),
          8.verticalSpace,
          Text(
            "Silahkan kembali,",
            style: TS.labelLarge,
            textAlign: TextAlign.center,
          ),
          Text(
            "tapi jangan kembali ke mantan",
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
