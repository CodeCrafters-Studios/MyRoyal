import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';

class SwitchMenuSettings extends StatelessWidget {
  const SwitchMenuSettings({
    super.key,
    required this.assetSvg,
    required this.text,
    required this.value,
    required this.onChanged,
  });

  final String assetSvg;
  final String text;
  final bool value;
  final Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(assetSvg),
        12.horizontalSpace,
        Expanded(
          child: Text(text, style: TS.labelLarge),
        ),
        SizedBox(
          width: 50,
          height: 40,
          child: FittedBox(
            fit: BoxFit.fill,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: white,
              activeTrackColor: primary,
              inactiveThumbColor: inactiveThumbColor,
              inactiveTrackColor: inactiveTrackColor,
            ),
          ),
        ),
      ],
    );
  }
}
