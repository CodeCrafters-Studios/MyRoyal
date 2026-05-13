import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:lottie/lottie.dart';

class EmptyDataWidget extends StatelessWidget {
  const EmptyDataWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        80.verticalSpace,
        Text(
          "Kami mohon maaf, kami tidak menemukan halaman yang Anda butuhkan.",
          style: TS.bodyMini.copyWith(fontSize: 12),
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
        8.verticalSpace,
        Text(
          "Silakan kembali,\ntetapi jangan kembali kepada mantan gebetanmu.",
          style: TS.labelSmall,
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
        Lottie.asset(
          'assets/json/lottie_empyt_box.json',
        ),
      ],
    );
  }
}
