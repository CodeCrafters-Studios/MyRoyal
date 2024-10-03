import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    required this.iconStatus,
    this.titleStyle,
    this.dateStyle,
    this.onTap,
  });

  final String date;
  final String status;
  final String description;
  final Color statusColor;
  final String types;
  final String iconStatus;
  final TextStyle? titleStyle;
  final TextStyle? dateStyle;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CardApp(
          onTap: onTap,
          margin: REdgeInsets.fromLTRB(30, 0, 30, 15),
          borderWidth: 1,
          isOutlined: true,
          width: Get.width,
          isShadow: true,
          shadows: Shadows.small,
          child: EPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  status,
                  style: TS.bodySmall.copyWith(
                    color: statusColor.withOpacity(0.8),
                  ),
                ),
                EPadding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style: titleStyle ??
                            TS.bodyLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      10.verticalSpace,
                      Text(
                        description,
                        style:
                            TS.bodyMedium.copyWith(fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 15,
          bottom: 0,
          child: CircleAvatar(
            backgroundColor: statusColor,
            radius: 20.r,
            child: SvgPicture.asset(
              height: 25,
              width: 25,
              iconStatus,
            ),
          ),
        ),
      ],
    );
  }
}
