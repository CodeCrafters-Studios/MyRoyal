import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/dashboard/presentation/views/widgets/dashboard_card.dart';
import 'package:MyRoyal/app/modules/leave_summary/presentation/views/permit_view.dart';
import 'package:MyRoyal/app/routes/app_pages.dart';
import 'package:MyRoyal/base/config/app_constants.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/widgets/appbar_spacer.dart';
import 'package:MyRoyal/base/widgets/page_base.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/leave_summary_controller.dart';

class LeaveSummaryView extends GetView<LeaveSummaryController> {
  const LeaveSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'Izin / Cuti',
      child: Obx(
        () => controller.isLoading.value ? _buildLoadingUI() : _buildLoadedUI(),
      ),
    );
  }

  Widget _buildLoadedUI() {
    return Obx(
      () => SingleChildScrollView(
        child: Column(
          children: [
            AppbarSpacer(),
            DashboardCard(
              title: 'Pengajuan\nCuti',
              value: controller
                  .leaveModelRes()
                  .data!
                  .yearlyLeaveCount!
                  .used
                  .toString(),
              totalValue: controller
                  .leaveModelRes()
                  .data!
                  .yearlyLeaveCount!
                  .max
                  .toString(),
              progressLinearValue: controller
                      .leaveModelRes()
                      .data!
                      .yearlyLeaveCount!
                      .used!
                      .toDouble() /
                  12,
              textColor: secondary,
              progressLinearColor: secondary,
              valueColor: secondary,
              backgroundImage: 'assets/images/img_bg_special_leave.png',
              iconAsset: 'assets/icons/ic_special_leaves.svg',
              isLateCard: false,
              onTap: () => Get.toNamed(Routes.LEAVES),
            ),
            5.verticalSpace,
            DashboardCard(
              title: 'Pengajuan\nIzin',
              value: controller.permitData.length.toString(),
              totalValue: '12',
              progressLinearValue: 12 / 12,
              textColor: primary20,
              progressLinearColor: primary20,
              valueColor: primary20,
              backgroundImage: 'assets/images/img_bg_request_leave.png',
              iconAsset: 'assets/icons/ic_request_leave.svg',
              isLateCard: true,
              onTap: () => Get.to(
                () => PermitView(),
              ),
            ),
            20.verticalSpace,
            LeavesViewImpl(controller: controller),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingUI() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppbarSpacer(),
            DashboardCard(
              title: 'Leave\nRequests',
              value: '',
              totalValue: '',
              progressLinearValue: 0,
              textColor: secondary,
              progressLinearColor: secondary,
              valueColor: secondary,
              backgroundImage: 'assets/images/img_bg_special_leave.png',
              iconAsset: 'assets/icons/ic_special_leaves.svg',
              isLateCard: false,
            ),
            5.verticalSpace,
            DashboardCard(
              title: 'Permit\nRequest',
              value: '0',
              totalValue: '0',
              progressLinearValue: 0,
              textColor: primary20,
              progressLinearColor: primary20,
              valueColor: primary20,
              backgroundImage: 'assets/images/img_bg_request_leave.png',
              iconAsset: 'assets/icons/ic_request_leave.svg',
              isLateCard: true,
            ),
          ],
        ),
      ),
    );
  }
}

class LeavesViewImpl extends StatelessWidget {
  const LeavesViewImpl({
    super.key,
    required this.controller,
  });

  final LeaveSummaryController controller;

  @override
  Widget build(BuildContext context) {
    return _buildLeaveRequestSection(context);
  }

  Widget _buildLeaveRequestSection(BuildContext context) {
    return emptyBox;
  }
}
