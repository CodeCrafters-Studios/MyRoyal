import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/padding.dart';

class LeaveRequestCard extends StatelessWidget {
  const LeaveRequestCard({
    super.key,
    required this.date,
    required this.status,
    required this.description,
    required this.statusColor,
    required this.types,
    this.titleStyle,
    this.dateStyle,
    this.onTap,
  });

  final String date;
  final String status;
  final String description;
  final Color statusColor;
  final String types;
  final TextStyle? titleStyle;
  final TextStyle? dateStyle;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return CardApp(
      onTap: onTap,
      margin: REdgeInsets.only(bottom: 15),
      borderWidth: 1,
      isOutlined: true,
      width: Get.width,
      isShadow: true,
      shadows: Shadows.small,
      child: EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    date,
                    style: titleStyle ??
                        TS.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Container(
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Corners.xll),
                    ),
                    color: statusColor.withOpacity(0.3),
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
            15.verticalSpace,
            Text(
              description,
              style: TS.bodyMedium.copyWith(fontWeight: FontWeight.w400),
            ),
            15.verticalSpace,
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: statusColor,
                  radius: 8.r,
                ),
                5.horizontalSpace,
                Text(
                  types,
                  style: dateStyle ??
                      TS.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
