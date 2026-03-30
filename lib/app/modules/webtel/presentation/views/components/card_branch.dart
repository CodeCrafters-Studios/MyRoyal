import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/inkwell_tap.dart';
import 'package:MyRoyal/base/widgets/padding.dart';

class BranchCard extends StatelessWidget {
  const BranchCard({
    super.key,
    required this.branchName,
    required this.branchCode,
    required this.totalbranch,
    required this.logo,
    required this.color,
    this.height = 80,
    required this.onTap,
  });

  final String branchName;
  final String branchCode;
  final String totalbranch;
  final String logo;
  final Color color;
  final int height;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return EPadding(
      padding: const EdgeInsets.all(8.0),
      child: InkWellTap(
        radius: 8.0,
        color: color.withOpacity(0.3),
        onTap: onTap,
        child: Card(
          elevation: 2,
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.asset(height: height.h, logo)),
                  30.verticalSpace,
                  EPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          totalbranch,
                          style: TS.titleMedium,
                        ),
                        const Spacer(),
                        Text(
                          'Employees',
                          style: TS.bodySmall,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
