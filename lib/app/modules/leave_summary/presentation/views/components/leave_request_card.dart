import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:search_highlight_text/search_highlight_text.dart';

class LeaveRequestCard extends StatelessWidget {
  const LeaveRequestCard({
    super.key,
    required this.code,
    required this.date,
    required this.status,
    required this.description,
    required this.statusColor,
    required this.iconStatus,
    this.titleStyle,
    this.dateStyle,
    this.onTap,
  });

  final String code;
  final String date;
  final String status;
  final String description;
  final Color statusColor;
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
          margin: REdgeInsets.fromLTRB(20, 0, 20, 15),
          borderWidth: 1,
          isOutlined: true,
          width: Get.width,
          isShadow: true,
          shadows: Shadows.small,
          child: EPadding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    EPadding(
                      padding: const EdgeInsets.only(left: 15),
                      child: SearchHighlightText(
                        code.capitalizeFirst.toString(),
                        style: TS.bodySmall.copyWith(
                          color: statusColor.withOpacity(0.8),
                        ),
                        highlightStyle: TS.labelLarge.copyWith(
                          color: statusColor.withOpacity(0.8),
                        ),
                      ),
                    ),
                    SearchHighlightText(
                      textAlign: TextAlign.end,
                      status.capitalizeFirst.toString(),
                      style: TS.bodySmall.copyWith(
                        color: statusColor.withOpacity(0.8),
                      ),
                      highlightStyle: TS.labelLarge.copyWith(
                        color: statusColor.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: SearchHighlightText(
                    date,
                    style: titleStyle ?? TS.bodyMedium.copyWith(color: black),
                    highlightStyle: TS.labelLarge.copyWith(color: black),
                  ),
                  subtitle: Text(
                    description,
                    style: TS.bodySmall.copyWith(
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.ellipsis,
                    ),
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
