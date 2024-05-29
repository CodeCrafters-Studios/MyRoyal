import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EImages extends StatelessWidget {
  const EImages({
    super.key,
    required this.name,
    this.height,
    this.width,
    this.radius,
    this.color,
    this.fit,
    this.expandWidth = false,
    this.expandHeight = false,
  });

  final String name;
  final double? height;
  final double? width;
  final double? radius;
  final Color? color;
  final BoxFit? fit;
  final bool expandWidth;
  final bool expandHeight;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      name,
      height: expandHeight
          ? context.height
          : radius != null
              ? radius?.r
              : height?.h,
      width: expandWidth
          ? context.width
          : radius != null
              ? radius?.r
              : width?.w,
      fit: fit ?? BoxFit.cover,
    );
  }
}
