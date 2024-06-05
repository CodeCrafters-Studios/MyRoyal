import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/base/design/styles.dart';

class AttendanceCard extends StatelessWidget {
  const AttendanceCard({
    super.key,
    required this.backgroundColor,
    required this.title,
    required this.subTitle,
  });

  final Color backgroundColor;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.all(8.0),
      width: 150.w,
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.2),
        border: Border(
          top: BorderSide(
            width: 2,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: backgroundColor,
          ),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(Corners.sm),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TS.titleSmall,
          ),
          8.verticalSpace,
          Text(
            subTitle,
            style: TS.bodyLarge.copyWith(
              color: backgroundColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
