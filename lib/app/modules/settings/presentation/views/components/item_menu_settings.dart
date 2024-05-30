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
    this.textStyle,
    this.withTrailing = false,
    this.icon,
    this.onTap,
  });
  final String assetSvg;
  final String text;
  final TextStyle? textStyle;
  final IconData? icon;
  final bool withTrailing;
  final Function()? onTap;

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
                    ? Icon(
                        icon ?? Icons.arrow_forward_ios_rounded,
                        color: primary,
                      )
                    : emptyBox,
              ],
            ),
          ),
        ),
        const AppDivider(),
      ],
    );
  }
}
