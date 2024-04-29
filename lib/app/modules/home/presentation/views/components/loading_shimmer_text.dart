import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';

class LoadingShimmerText extends StatelessWidget {
  const LoadingShimmerText({
    super.key,
    required this.width,
    this.padding,
    this.margin,
  });

  final double width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding ?? REdgeInsets.only(left: 8, top: 8, bottom: 10),
      margin: margin ?? REdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
        border: Border.all(color: grey, width: 0),
        color: primary,
        boxShadow: Shadows.small,
      ),
    );
  }
}
