import 'package:MyRoyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/card/card_app.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:shimmer/shimmer.dart';

class HomeUserStatus extends GetView<HomeController> {
  const HomeUserStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Obx(
        () => EPadding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child:
              controller.isLoading.value ? _buildLoading() : _buildStatusRow(),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: EPadding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: ShimmerText(
                width: 150.w,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 88.h,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: Container(
                  height: 88.h,
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 3.w,
              height: 16.h,
              decoration: BoxDecoration(
                gradient: Gradients.primaryAccent(),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            8.horizontalSpace,
            Text(
              'Attendance Information',
              style: TS.titleSmall.copyWith(color: primary),
            ),
          ],
        ),
        12.verticalSpace,
        Row(
          children: [
            Expanded(
              child: _StatusCard(
                label: 'Last Check In',
                day: controller.userData.value.data.absentStartDay.isNotEmpty
                    ? controller.userData.value.data.absentStartDay
                    : '-',
                time: controller.userData.value.data.absentStartTime.isNotEmpty
                    ? controller.userData.value.data.absentStartTime
                    : '00:00:00',
                accentColor: green,
                icon: Icons.login_rounded,
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: _StatusCard(
                label: 'Last Check Out',
                day: controller.userData.value.data.absentEndDay.isNotEmpty
                    ? controller.userData.value.data.absentEndDay
                    : '-',
                time: controller.userData.value.data.absentEndTime.isNotEmpty
                    ? controller.userData.value.data.absentEndTime
                    : '00:00:00',
                accentColor: secondary,
                icon: Icons.logout_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.label,
    required this.day,
    required this.time,
    required this.accentColor,
    required this.icon,
  });

  final String label;
  final String day;
  final String time;
  final Color accentColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return CardApp(
      color: white,
      radius: 14,
      padding: REdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  icon,
                  color: accentColor,
                  size: 18.w,
                ),
              ),
              8.horizontalSpace,
              Expanded(
                child: Text(
                  label,
                  style: TS.labelSmall.copyWith(color: greyText),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          10.verticalSpace,
          Text(
            day,
            style: TS.labelMedium.copyWith(
              color: primary,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          4.verticalSpace,
          Row(
            children: [
              1.horizontalSpace,
              Text(
                "●",
                style: TS.labelSmall.copyWith(color: accentColor),
              ),
              5.horizontalSpace,
              Text(
                time,
                style: TS.labelSmall.copyWith(color: accentColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
