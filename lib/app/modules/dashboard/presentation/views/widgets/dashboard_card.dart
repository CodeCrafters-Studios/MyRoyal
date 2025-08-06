import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/card/card_app.dart';
import 'package:iroyal/base/widgets/padding.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.title,
    required this.backgroundImage,
    required this.value,
    required this.totalValue,
    required this.progressLinearValue,
    required this.textColor,
    required this.progressLinearColor,
    required this.valueColor,
    required this.iconAsset,
    required this.isLateCard,
    this.onTap,
  });

  final String title, backgroundImage, value, totalValue, iconAsset;
  final double progressLinearValue;
  final Color textColor, progressLinearColor, valueColor;
  final bool isLateCard;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.transparent,
        ),
        CardApp(
          onTap: onTap,
          margin: REdgeInsets.only(left: 14, right: 14),
          width: 330.w,
          shadows: Shadows.small,
          color: white,
          child: Stack(
            children: [
              Image.asset(
                backgroundImage,
                fit: BoxFit.cover,
              ),
              EPadding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    5.verticalSpace,
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        isLateCard ? '$value Times' : '$value/$totalValue',
                        style: TS.titleMedium.copyWith(color: valueColor),
                      ),
                    ),
                    isLateCard ? emptyBox : 10.verticalSpace,
                    Visibility(
                      visible: !isLateCard,
                      child: SizedBox(
                        width: 140.w,
                        child: LinearProgressIndicator(
                          value: progressLinearValue,
                          minHeight: 8.h,
                          color: progressLinearColor,
                          backgroundColor: grey,
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                    ),
                    isLateCard ? emptyBox : 10.verticalSpace,
                    Text(
                      title,
                      style: TS.titleLarge.copyWith(color: textColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 15.w,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 2,
                  color: Colors.grey,
                  spreadRadius: 1,
                )
              ],
            ),
            child: CircleAvatar(
              backgroundColor: white,
              child: SvgPicture.asset(
                height: 24.h,
                iconAsset,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
