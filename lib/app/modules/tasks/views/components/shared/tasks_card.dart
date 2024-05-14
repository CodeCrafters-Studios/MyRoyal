import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/padding.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.title,
    required this.status,
    required this.member,
    required this.progress,
    required this.statusColor,
    required this.dueDate,
    this.titleStyle,
    this.dateStyle,
    this.progressColor,
  });

  final String title;
  final String status;
  final String member;
  final double progress;
  final Color statusColor;
  final String dueDate;
  final TextStyle? titleStyle;
  final TextStyle? dateStyle;
  final Color? progressColor;

  @override
  Widget build(BuildContext context) {
    return CardApp(
      margin: REdgeInsets.only(bottom: 15),
      borderWidth: 1,
      isOutlined: true,
      width: Get.width,
      isShadow: true,
      shadows: Shadows.small,
      child: EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    title,
                    style: titleStyle ??
                        TS.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                Container(
                  width: 100.w,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(24),
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
            10.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: TS.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  progress != 0
                      ? '${(progress * 100).toInt()}% complete'
                      : 'Canceled',
                  style: TS.bodyMedium.copyWith(
                    color: progress != 0
                        ? progressColor?.withOpacity(0.8) ??
                            statusColor.withOpacity(0.8)
                        : greyText,
                  ),
                ),
              ],
            ),
            15.verticalSpace,
            LinearProgressIndicator(
              color: progressColor,
              backgroundColor: greyHint,
              value: progress,
            ),
            15.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Due Date: $dueDate',
                  style: dateStyle ??
                      TS.bodyMedium.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                ),
                Row(
                  children: [
                    Text(
                      '$member persons',
                      style: TS.bodyMedium.copyWith(
                        fontWeight: FontWeight.w400,
                        decoration: status == 'Canceled'
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    5.horizontalSpace,
                    const Icon(
                      Icons.people_alt_outlined,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
