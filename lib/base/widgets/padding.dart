import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EPadding extends StatelessWidget {
  const EPadding({
    super.key,
    required this.padding,
    required this.child,
  });

  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding.copyWith(
        top: padding.top.h,
        bottom: padding.bottom.h,
        left: padding.left.w,
        right: padding.right.w,
      ),
      child: child,
    );
  }
}
