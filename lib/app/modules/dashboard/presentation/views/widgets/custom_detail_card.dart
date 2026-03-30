import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';

class CustomDetailCard extends StatelessWidget {
  const CustomDetailCard({
    super.key,
    required this.borderSideColor,
    required this.time,
    required this.dateStart,
    required this.dateEnd,
    required this.typeRequest,
    this.isSpecialLeave = false,
  });

  final Color borderSideColor;
  final String time, dateStart, dateEnd, typeRequest;
  final bool isSpecialLeave;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 4,
            color: borderSideColor,
          ),
          top: BorderSide(
            color: grey,
          ),
          right: BorderSide(
            color: grey,
          ),
          bottom: BorderSide(
            color: grey,
          ),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            10.horizontalSpace,
            Text(
              isSpecialLeave ? time : '$time WIB',
              style: TS.titleSmall.copyWith(fontWeight: FontWeight.w500),
            ),
            10.horizontalSpace,
            SizedBox(
              height: 35.h,
              child: VerticalDivider(
                color: grey,
              ),
            ),
            10.horizontalSpace,
            typeRequest == 'Late'
                ? Text(
                    dateStart,
                    style: TS.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : Text(
                    '$dateStart - $dateEnd}',
                    style: TS.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
