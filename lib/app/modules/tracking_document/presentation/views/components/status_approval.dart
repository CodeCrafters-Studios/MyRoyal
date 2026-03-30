import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:MyRoyal/base/design/styles.dart';

class StatusApproval extends StatelessWidget {
  const StatusApproval({
    super.key,
    required this.icon,
    required this.status,
    required this.iconColor,
    required this.statusColor,
    required this.borderColor,
    required this.decorationColor,
  });

  final IconData icon;
  final String status;
  final Color iconColor;
  final Color statusColor;
  final Color borderColor;
  final Color decorationColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: REdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            color: decorationColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(Corners.xll),
          ),
          child: Row(
            children: [
              Icon(
                applyTextScaling: true,
                icon,
                color: iconColor,
                size: 20.dm,
              ),
              2.horizontalSpace,
              Text(
                status,
                style: TS.labelMedium.copyWith(color: statusColor),
              )
            ],
          ),
        ),
        10.horizontalSpace,
      ],
    );
  }
}
