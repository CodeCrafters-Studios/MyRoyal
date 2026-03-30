import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/padding.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: REdgeInsets.only(left: 5),
      width: 160.w,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: grey),
        borderRadius: const BorderRadius.all(
          Radius.circular(50),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            child: SizedBox(
              width: 28.w,
              height: 30.h,
              child: const CircleAvatar(),
            ),
          ),
          Text(
            'User Name',
            style: TS.bodySmall,
          ),
          const EPadding(
            padding: EdgeInsets.only(left: 4, right: 10),
            child: Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}
