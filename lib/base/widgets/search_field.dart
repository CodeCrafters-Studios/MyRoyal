import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';

class ESearchField extends StatelessWidget {
  const ESearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hintText = 'Search',
    this.focusedColor = primary,
    this.borderColor = grey,
  });

  final TextEditingController controller;
  final Function(String) onChanged;
  final String hintText;
  final Color focusedColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return EPadding(
      padding: const EdgeInsets.only(
        left: 18,
        right: 18,
        top: 20,
        bottom: 8,
      ),
      child: InputPrimary(
        key: const Key('searchUser'),
        label: '',
        hint: 'Search',
        onChanged: (_) {},
        prefixIcon: Padding(
          padding: REdgeInsets.symmetric(horizontal: 12),
          child: SvgPicture.asset(
            'assets/icons/ic_search.svg',
            width: 20.w,
            height: 20.w,
          ),
        ),
      ),
    );
  }
}
