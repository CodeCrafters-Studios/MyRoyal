import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          child: Image.asset('assets/icons/ic_no_notifications.png'),
        ),
        30.verticalSpace,
        EPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
              Text(
                'Belum ada notifikasi',
                style: TS.titleMedium,
              ),
              Text(
                'Saat ini kamu belum memiliki notifikasi apapun.',
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
