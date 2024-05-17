import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';

class TaskTypeCard extends StatelessWidget {
  const TaskTypeCard({
    super.key,
    required this.type,
    required this.onTap,
    required this.texColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  final String type;
  final Color texColor;
  final Color backgroundColor;
  final Color borderColor;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWellTap(
      onTap: onTap,
      child: Container(
        width: 120.w,
        height: 50.h,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          color: backgroundColor,
        ),
        child: Center(
          child: Text(
            type,
            style: TS.bodyMedium.copyWith(color: texColor),
          ),
        ),
      ),
    );
  }
}
