import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/inkwell_tap.dart';
import 'package:MyRoyal/base/widgets/padding.dart';

class TaskCategoryCard extends StatelessWidget {
  const TaskCategoryCard({
    required this.title,
    required this.tasksCount,
    required this.color,
    required this.icon,
    required this.onTap,
    super.key,
  });

  final String title;
  final int tasksCount;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWellTap(
      onTap: onTap,
      child: Container(
        height: 150.h,
        width: 200.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(Corners.slg),
          ),
          color: color.withOpacity(0.8),
        ),
        child: EPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Icon(icon, size: 25.dm, color: white),
              ),
              Text(
                title,
                style: TS.bodyLarge
                    .copyWith(color: white, fontWeight: FontWeight.w600),
              ),
              10.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$tasksCount Tasks',
                    style: TS.bodyMedium.copyWith(color: white),
                  ),
                  const Icon(Icons.arrow_forward, color: white),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
