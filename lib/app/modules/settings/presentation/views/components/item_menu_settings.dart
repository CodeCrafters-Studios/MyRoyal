import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:MyRoyal/base/config/app_constants.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/app_divider.dart';

class ItemMenuSettings extends StatelessWidget {
  const ItemMenuSettings({
    super.key,
    required this.assetSvg,
    required this.text,
    this.appVersion = '',
    this.textStyle,
    this.textStyleTrailing,
    this.withTrailing = false,
    this.trailingIcon = true,
    this.icon,
    this.onTap,
    this.onTapIcon,
    this.withDivider = true,
    this.iconColor,
  });
  final String assetSvg;
  final String text;
  final String appVersion;
  final TextStyle? textStyle, textStyleTrailing;
  final IconData? icon;
  final bool withTrailing;
  final bool trailingIcon;
  final Function()? onTap;
  final Function()? onTapIcon;
  final bool withDivider;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: REdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                SvgPicture.asset(assetSvg, color: iconColor),
                12.horizontalSpace,
                Expanded(
                  child: Text(text, style: textStyle ?? TS.labelLarge),
                ),
                withTrailing
                    ? trailingIcon
                        ? InkWell(
                            onTap: onTapIcon,
                            child: Icon(
                              icon ?? Icons.arrow_forward_ios_rounded,
                              color: primary,
                            ),
                          )
                        : Text(
                            'Version $appVersion',
                            style: textStyleTrailing ??
                                TS.bodySmall
                                    .copyWith(fontWeight: FontWeight.w500),
                          )
                    : emptyBox,
              ],
            ),
          ),
        ),
        withDivider ? const AppDivider() : emptyBox,
      ],
    );
  }
}
