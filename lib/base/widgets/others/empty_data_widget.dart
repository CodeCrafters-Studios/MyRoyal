import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/base/design/styles.dart';
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
        Text("We'are sorry, we didn't found the page you need.",
            style: TS.bodyMini.copyWith(fontSize: 12)),
        8.verticalSpace,
        Text(
          "Please go back,\nbut please don't go back to your ex-crush",
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
