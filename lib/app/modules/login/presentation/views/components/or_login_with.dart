import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';

class OrLoginWith extends StatelessWidget {
  const OrLoginWith({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: grey,
          ),
        ),
        20.horizontalSpace,
        Text(
          'Or login with',
          style: TS.bodySmall,
        ),
        20.horizontalSpace,
        Expanded(
          child: Container(
            height: 1,
            color: grey,
          ),
        ),
      ],
    );
  }
}
