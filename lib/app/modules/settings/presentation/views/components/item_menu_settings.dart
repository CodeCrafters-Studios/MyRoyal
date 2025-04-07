import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/app_divider.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';

class ItemMenuSettings extends StatelessWidget {
  const ItemMenuSettings({
    super.key,
    required this.assetSvg,
    required this.text,
    this.appVersion = '',
    this.textStyle,
    this.withTrailing = false,
    this.trailingIcon = true,
    this.icon,
    this.onTap,
    this.onTapIcon,
    this.withDivider = true,
  });
  final String assetSvg;
  final String text;
  final String appVersion;
  final TextStyle? textStyle;
  final IconData? icon;
  final bool withTrailing;
  final bool trailingIcon;
  final Function()? onTap;
  final Function()? onTapIcon;
  final bool withDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWellTap(
          onTap: onTap,
          child: Padding(
            padding: REdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                SvgPicture.asset(assetSvg),
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
                            style: TS.bodySmall
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
