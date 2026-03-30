import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/padding.dart';

class NoNotificationsView extends StatelessWidget {
  const NoNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildNotificationsIcon();
  }

  Widget _buildNotificationsIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 100.h,
          width: 100.w,
          color: white,
          child: Image.asset('assets/icons/ic_no_notifications.png'),
        ),
        30.verticalSpace,
        EPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
              Text(
                'No Notifications',
                style: TS.titleMedium,
              ),
              15.verticalSpace,
              Text(
                'You do not have any\nnotifications at this time',
                style: TS.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
      ],
    );
  }
}
