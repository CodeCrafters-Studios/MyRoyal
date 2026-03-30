import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:MyRoyal/base/widgets/textfield/input_primary.dart';

class SearchBarCustom extends StatelessWidget {
  const SearchBarCustom({
    super.key,
    required this.hint,
    required this.onChanged,
    required this.label,
  });

  final String hint;
  final String label;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: InputPrimary(
        key: key,
        label: label,
        hint: hint,
        color: white,
        outlineColor: primary,
        prefixIcon: EPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SvgPicture.asset(
            'assets/icons/ic_search.svg',
            width: 20.w,
            height: 20.w,
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
