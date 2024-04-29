import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/padding.dart';

class NoResultWidget extends StatelessWidget {
  const NoResultWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 250.h,
          child: SizedBox(
            height: 350.h,
            width: 350.w,
            child: Image.asset('assets/images/img_no-result.gif'),
          ),
        ),
        Positioned(
          top: 300.h,
          left: 0,
          right: 0,
          bottom: 0,
          child: EPadding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                Text("Sorry! No Result Found :(", style: TS.bodyMini),
                Text(
                  "We'are sorry what you were looking for. Please try another keys.",
                  style: TS.labelSmall,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
