import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';

class RowDetailsEarningAndDeductions extends StatelessWidget {
  const RowDetailsEarningAndDeductions({
    super.key,
    required this.title,
    required this.value,
    this.titleStyle,
    this.valueStyle,
    this.withBackground = false,
  });

  final String title;
  final String value;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final bool withBackground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.symmetric(horizontal: 4),
      height: 40.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8.r),
        ),
        color: withBackground ? grey50 : Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: titleStyle ?? TS.bodyMedium,
          ),
          Text(
            value,
            style: valueStyle ?? TS.bodyMedium,
          ),
        ],
      ),
    );
  }
}
