import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/base/design/styles.dart';

class NoResultFoundWidget extends StatelessWidget {
  const NoResultFoundWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          'assets/images/img_no-result.gif',
          height: 250.h,
          width: 250.w,
        ),
        Text("Sorry! No Result Found :(",
            style: TS.bodyMini.copyWith(fontSize: 12)),
        8.verticalSpace,
        Text(
          "We'are sorry what you were looking for.\nPlease try another keys.",
          style: TS.labelSmall,
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
