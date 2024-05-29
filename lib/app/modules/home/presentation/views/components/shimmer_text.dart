import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerText extends StatelessWidget {
  const ShimmerText({
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
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        padding: padding ?? REdgeInsets.only(left: 8, top: 8, bottom: 10),
        margin: margin ?? REdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Corners.smRadius,
          ),
          border: Border.all(color: grey, width: 0),
          boxShadow: Shadows.small,
          color: greyText,
        ),
      ),
    );
  }
}
