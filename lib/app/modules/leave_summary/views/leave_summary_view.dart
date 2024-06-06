import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:iroyal/app/modules/leave_summary/views/components/apply_leave_view.dart';
import 'package:iroyal/app/modules/leave_summary/views/components/tabs/tab_all_leave_req.dart';
import 'package:iroyal/app/modules/leave_summary/views/components/tabs/tab_casual_leave_req.dart';
import 'package:iroyal/app/modules/leave_summary/views/components/tabs/tab_sick_leave_req.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';

import '../controllers/leave_summary_controller.dart';

class LeaveSummaryView extends GetView<LeaveSummaryController> {
  const LeaveSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'Leave Summary',
      child: LeaveSummaryViewImpl(controller: controller),
    );
  }
}

class LeaveSummaryViewImpl extends StatelessWidget {
  const LeaveSummaryViewImpl({
    super.key,
    required this.controller,
  });

  final LeaveSummaryController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          children: [
            const AppbarSpacer(),
            _buildLeaveRequestSection(),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildTypesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Types", style: TS.bodyLarge),
        10.verticalSpace,
        _buildTypeRow("Casual", 0.5, "05/08"),
        10.verticalSpace,
        _buildTypeRow("Sick", 0.3, "03/08"),
      ],
    );
  }

  Widget _buildTypeRow(String type, double value, String ratio) {
    return Row(
      children: [
        Text(type, style: TS.bodyMedium),
        10.horizontalSpace,
        Expanded(
          child: LinearProgressIndicator(
            color: type == "Casual" ? primary : secondary,
            backgroundColor: greyHint,
            value: value,
          ),
        ),
        10.horizontalSpace,
        Text(ratio, style: TS.bodyMedium),
      ],
    );
  }

  Widget _buildLeaveRequestSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLeaveRequestHeader(),
        5.verticalSpace,
        _buildTypesSection(),
        25.verticalSpace,
        _buildLeaveRequestTabs(),
        20.verticalSpace,
        _buildLeaveRequestTabViews(),
      ],
    );
  }

  Widget _buildLeaveRequestHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Leave Request', style: TS.titleMedium),
        ButtonPrimary(
          margin: REdgeInsets.only(top: 5),
          color: white,
          borderSide: const BorderSide(color: primary),
          fullWidth: false,
          onPressed: () => Get.to(() => ApplyLeaveView(controller: controller)),
          child: Row(
            children: [
              Icon(Icons.add, size: 20.dm, color: primary),
              5.horizontalSpace,
              Text(
                'Create',
                style: TS.bodyMedium.copyWith(
                  color: primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeaveRequestTabs() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: grey),
        borderRadius: BorderRadius.circular(Corners.slg),
        color: white,
      ),
      child: TabBar(
        controller: controller.tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(Corners.slg),
          color: primary,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: TS.bodyMedium.copyWith(color: white),
        unselectedLabelStyle: TS.bodyMedium.copyWith(color: primary),
        unselectedLabelColor: primary,
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Casual'),
          Tab(text: 'Sick'),
        ],
      ),
    );
  }

  Widget _buildLeaveRequestTabViews() {
    return Container(
      padding: REdgeInsets.symmetric(horizontal: 14),
      width: Get.width,
      height: 500.h,
      child: TabBarView(
        controller: controller.tabController,
        children: [
          TabAllLeaveRequest(controller: controller),
          TabCasualLeaveRequest(controller: controller),
          TabSickLeaveRequest(controller: controller),
        ],
      ),
    );
  }
}
