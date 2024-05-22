import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';

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
    return CardApp(
      color: color ??
          (Get.isDarkMode
              ? bgColorDark.withOpacity(.6)
              : bgColor.withOpacity(.7)),
      height: dAppbarHeight + MediaQuery.of(context).viewPadding.top,
      margin: EdgeInsets.zero,
      width: Get.width,
      radius: 0,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 6,
                sigmaY: 6,
              ),
              child: Container(
                width: Get.width,
                height: dAppbarHeight + MediaQuery.of(context).viewPadding.top,
                color: color ??
                    (Get.isDarkMode
                        ? Colors.black.withOpacity(.2)
                        : Colors.white.withOpacity(.1)),
              ),
            ),
          ),
          Row(
            children: [
              if (showIconBack)
                SizedBox(
                  height: dAppbarHeight,
                  child: InkWellTap(
                    onTap: onBack ?? Get.back,
                    child: Padding(
                      padding: REdgeInsets.fromLTRB(16, 8, 8, 8),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18.w,
                        color: iconColor ?? Colors.black,
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: Container(
                  height: dAppbarHeight,
                  padding: centeredTitle
                      ? EdgeInsets.zero
                      : REdgeInsets.only(left: showIconBack ? 8 : 16),
                  child: Align(
                    alignment:
                        centeredTitle ? Alignment.center : Alignment.centerLeft,
                    child: Text(
                      title,
                      style: textStyle ?? TS.titleSmall,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
        ],
      ),
    );
  }
}
