import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/padding.dart';

class HeaderDetailTask extends StatelessWidget {
  const HeaderDetailTask({
    super.key,
    required this.title,
    required this.status,
    required this.statusColor,
    required this.bgStatusColor,
  });

  final String title;
  final String status;
  final Color statusColor;
  final Color bgStatusColor;

  @override
  Widget build(BuildContext context) {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        children: [
          const AppbarSpacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  title,
                  style: TS.titleMedium.copyWith(
                    color: primary,
                    fontSize: 18.dm,
                  ),
                ),
              ),
              Container(
                width: 95.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Corners.xll),
                  ),
                  color: bgStatusColor.withOpacity(0.3),
                ),
                child: Center(
                  child: Text(
                    status,
                    style: TS.bodyMedium.copyWith(
                      color: statusColor.withOpacity(0.8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
