import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';
import 'package:iroyal/base/widgets/padding.dart';

class BranchCard extends StatelessWidget {
  const BranchCard({
    super.key,
    required this.branchName,
    required this.branchCode,
    required this.totalbranch,
    required this.logo,
    required this.color,
    required this.onTap,
  });

  final String branchName;
  final String branchCode;
  final String totalbranch;
  final String logo;
  final Color color;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return EPadding(
      padding: const EdgeInsets.all(8.0),
      child: InkWellTap(
        radius: 8.0,
        color: color.withOpacity(0.3),
        onTap: onTap,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              child: Container(
                width: 50.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.5),
                  borderRadius: BorderRadius.all(
                    Corners.smRadius,
                  ),
                ),
                child: Center(
                  child: Text(
                    branchCode,
                    style: TS.titleSmall.copyWith(color: white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  10.verticalSpace,
                  SizedBox(
                    width: 70.w,
                    height: 75.h,
                    child: CircleAvatar(
                      backgroundImage: AssetImage(logo),
                    ),
                  ),
                  10.verticalSpace,
                  Text(
                    '$totalbranch\nEmployees',
                    style: TS.titleSmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
