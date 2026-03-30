import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:MyRoyal/base/config/app_config.dart';

class AppbarSpacer extends StatelessWidget {
  const AppbarSpacer({
    super.key,
    this.height,
  });

  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ??
          AppConfig.iAppBarHeight +
              MediaQuery.of(context).viewPadding.top +
              8.h,
    );
  }
}
