import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/dashboard/presentation/views/widgets/dashboard_card.dart';
import 'package:iroyal/app/modules/leave_summary/presentation/views/components/all_leave_request_view.dart';
import 'package:iroyal/app/modules/leave_summary/presentation/views/permit_view.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/leave_summary_controller.dart';

class LeaveSummaryView extends GetView<LeaveSummaryController> {
  const LeaveSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'Leaves',
      child: Obx(
        () => controller.isLoading.value ? _buildLoadingUI() : _buildLoadedUI(),
      ),
    );
  }

  Widget _buildLoadedUI() {
    return SingleChildScrollView(
      child: Column(
        children: [
          AppbarSpacer(),
          DashboardCard(
            title: 'Leave\nRequests',
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
            title: 'Permit\nRequest',
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
            // 20.verticalSpace,
            // LeavesViewImpl(controller: controller),
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
    // Obx(
    //   () => Column(
    //     mainAxisSize: MainAxisSize.min,
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       // _buildSearch(),
    //       // 20.verticalSpace,
    //       // _buildAllLeaveRequestView(),
    //       // 20.verticalSpace,
    //       // controller.userData.value.position != 'Staff'
    //       //     ? _buildLeaveRequestTabViews()
    //       //     : emptyBox
    //     ],
    //   ),
    // );
  }

  // Widget _buildLeaveRequestTabViews() {
  //   return SizedBox(
  //     width: Get.width,
  //     height: Get.height,
  //     child: TabBarView(
  //       controller: controller.tabLeaveController,
  //       children: [
  //         AllLeaveRequestView(controller: controller),
  //         AllApprovalRequestView(controller: controller),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildAllLeaveRequestView() {
    return controller.userData.value.position != 'Staff'
        ? EPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: grey),
                borderRadius: BorderRadius.circular(Corners.xxl),
                color: white,
              ),
              child: TabBar(
                controller: controller.tabLeaveController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(Corners.xxl),
                  color: primary,
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: TS.bodyMedium.copyWith(color: white),
                unselectedLabelStyle: TS.bodyMedium.copyWith(color: primary),
                unselectedLabelColor: primary,
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Need Approval'),
                ],
              ),
            ),
          )
        : AllLeaveRequestView(controller: controller);
  }
}
