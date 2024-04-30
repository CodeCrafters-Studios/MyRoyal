import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/base/config/app_config.dart';

class AppbarSpacer extends StatelessWidget {
  const AppbarSpacer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppConfig.iAppBarHeight +
          MediaQuery.of(context).viewPadding.top +
          10.h,
    );
  }
}
