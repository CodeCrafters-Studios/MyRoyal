import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import 'package:MyRoyal/app/modules/attendance/presentation/controllers/attendance_controller.dart';

/// Single shimmering block used by all attendance placeholders.
class AttendanceShimmerBox extends StatelessWidget {
  const AttendanceShimmerBox({
    super.key,
    this.width,
    required this.height,
    this.radius = 8,
    this.circle = false,
  });

  final double? width;
  final double height;
  final double radius;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: circle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: circle ? null : BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// Shown only while nothing has been loaded yet. The attendance state is
/// unknown at that point, so the action area is neutral instead of
/// pretending to be the Check In layout. Sizes mirror the real content to
/// avoid layout jumps.
class AttendanceInitialShimmer extends StatelessWidget {
  const AttendanceInitialShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('attendance-initial-shimmer'),
      children: [
        AttendanceShimmerBox(width: double.infinity, height: 330.h, radius: 0),
        10.verticalSpace,
        const AttendanceShimmerBox(width: 140, height: 28),
        8.verticalSpace,
        const AttendanceShimmerBox(width: 200, height: 16),
        30.verticalSpace,
        const AttendanceShimmerBox(width: 220, height: 48, radius: 24),
      ],
    );
  }
}

/// Placeholder for the action area while an attendance action is being
/// submitted/confirmed. Its shape matches the buttons of [status], so a
/// checked-in employee sees Check Out + Take a Break placeholders, never the
/// Check In circle.
class AttendanceActionShimmer extends StatelessWidget {
  const AttendanceActionShimmer({super.key, required this.status});

  final AttendanceStatus status;

  static const _buttonHeight = 48.0;
  static const _buttonWidth = 130.0;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case AttendanceStatus.notStarted:
        return Column(
          key: const ValueKey('action-shimmer-not-started'),
          children: [
            AttendanceShimmerBox(height: 160.r, width: 160.r, circle: true),
            10.verticalSpace,
            const AttendanceShimmerBox(width: 240, height: 16),
            10.verticalSpace,
          ],
        );
      case AttendanceStatus.checkedIn:
        return const Row(
          key: ValueKey('action-shimmer-checked-in'),
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AttendanceShimmerBox(
                width: _buttonWidth, height: _buttonHeight, radius: 24),
            SizedBox(width: 10),
            AttendanceShimmerBox(
                width: _buttonWidth, height: _buttonHeight, radius: 24),
          ],
        );
      case AttendanceStatus.breakStart:
        return const Padding(
          key: ValueKey('action-shimmer-break-start'),
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: AttendanceShimmerBox(
              width: double.infinity, height: _buttonHeight, radius: 24),
        );
      case AttendanceStatus.breakEnd:
        return const AttendanceShimmerBox(
          key: ValueKey('action-shimmer-break-end'),
          width: _buttonWidth,
          height: _buttonHeight,
          radius: 24,
        );
      case AttendanceStatus.checkedOut:
        return const SizedBox.shrink(
            key: ValueKey('action-shimmer-checked-out'));
    }
  }
}
