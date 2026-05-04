import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/inkwell_tap.dart';

class AppbarDefault extends StatelessWidget {
  const AppbarDefault({
    super.key,
    this.onBack,
    this.showIconBack = true,
    this.title = 'Appbar Title',
    this.centeredTitle = false,
    this.actions,
    this.isShowLogo = true,
    this.color,
    this.textStyle,
    this.iconColor,
  });
  final Function()? onBack;
  final bool showIconBack;
  final String title;
  final bool centeredTitle;
  final List<Widget>? actions;
  final bool isShowLogo;
  final Color? color;
  final TextStyle? textStyle;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    const dAppbarHeight = 60.0;
    final topPadding = MediaQuery.of(context).viewPadding.top;
    final totalHeight = dAppbarHeight + topPadding;

    // Detect if a custom (non-brand) color was passed
    final bool useBrandGradient = color == null ||
        color == primary ||
        color == primaryColor;

    return SizedBox(
      height: totalHeight,
      width: Get.width,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            height: totalHeight,
            width: Get.width,
            decoration: BoxDecoration(
              gradient: useBrandGradient && !Get.isDarkMode
                  ? Gradients.primary()
                  : null,
              color: useBrandGradient
                  ? null
                  : (color ??
                      (Get.isDarkMode
                          ? bgColorDark.withOpacity(0.9)
                          : white.withOpacity(0.92))),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(top: topPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (showIconBack)
                    SizedBox(
                      height: dAppbarHeight,
                      child: InkWellTap(
                        onTap: onBack ?? Get.back,
                        child: Padding(
                          padding: REdgeInsets.fromLTRB(14, 8, 6, 8),
                          child: Container(
                            width: 34.w,
                            height: 34.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 16.w,
                              color: iconColor ??
                                  (useBrandGradient ? white : primary),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Container(
                      height: dAppbarHeight,
                      padding: centeredTitle
                          ? EdgeInsets.zero
                          : REdgeInsets.only(
                              left: showIconBack ? 4 : 16),
                      child: Align(
                        alignment: centeredTitle
                            ? Alignment.center
                            : Alignment.centerLeft,
                        child: Text(
                          title,
                          style: textStyle ??
                              TS.titleSmall.copyWith(
                                color: iconColor ??
                                    (useBrandGradient ? white : primary),
                                fontSize: 15.sp,
                              ),
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  if (actions != null) ...actions!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
