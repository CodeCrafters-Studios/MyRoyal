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
      child: Column(
        children: [
          const AppbarSpacer(),
          _buildLeaveRequestSection(),
          20.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildTypesSection() {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTypeRow("Casual", 0.5, "05/08"),
          10.verticalSpace,
          _buildTypeRow("Sick", 0.3, "03/08"),
        ],
      ),
    );
  }

  Widget _buildTypeRow(String type, double value, String ratio) {
    return Row(
      children: [
        Text(type, style: TS.bodyMedium),
        type == "Casual" ? 10.horizontalSpace : 28.horizontalSpace,
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
        10.verticalSpace,
        _buildTypesSection(),
        25.verticalSpace,
        _buildLeaveRequestTabs(),
        20.verticalSpace,
        _buildLeaveRequestTabViews(),
      ],
    );
  }

  Widget _buildLeaveRequestHeader() {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Leave Request', style: TS.titleMedium),
          ButtonPrimary(
            borderRadius: Corners.xxl,
            margin: REdgeInsets.only(top: 5),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: urgentColor,
            borderSide: const BorderSide(color: urgentColor),
            onPressed: () =>
                Get.to(() => ApplyLeaveView(controller: controller)),
            child: Row(
              children: [
                Icon(Icons.add, size: 18.dm, color: white),
                5.horizontalSpace,
                Text(
                  'Create New',
                  style: TS.bodySmall.copyWith(
                    color: white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveRequestTabs() {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: grey),
          borderRadius: BorderRadius.circular(Corners.xxl),
          color: white,
        ),
        child: TabBar(
          controller: controller.tabController,
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
            Tab(text: 'Casual'),
            Tab(text: 'Sick'),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaveRequestTabViews() {
    return SizedBox(
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
