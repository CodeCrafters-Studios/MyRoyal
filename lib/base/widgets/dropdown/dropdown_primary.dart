import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';

class DropDownPrimary extends StatelessWidget {
  const DropDownPrimary({
    super.key,
    required this.label,
    required this.hintText,
    required this.value,
    this.icon,
    this.borderColor,
    this.hintTextStyle,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final String hintText;
  final String? value;
  final Widget? icon;
  final Color? borderColor;
  final TextStyle? hintTextStyle;
  final List<DropdownMenuItem<String>>? items;
  final void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label.isEmpty
            ? emptyBox
            : Text(
                label,
                style: TS.labelLarge,
              ),
        4.verticalSpace,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          width: Get.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor ?? grey),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              icon: icon,
              alignment: Alignment.centerLeft,
              dropdownColor: white,
              style: const TextStyle(color: Colors.black),
              items: items,
              hint: Text(
                hintText,
                style: hintTextStyle ??
                    TS.bodyMedium.copyWith(
                      color: grey,
                    ),
              ),
              value: value,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
