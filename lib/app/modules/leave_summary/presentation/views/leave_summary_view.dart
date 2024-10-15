import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:iroyal/app/modules/leave_summary/presentation/views/components/all_approval_request_view.dart';

import 'package:iroyal/app/modules/leave_summary/presentation/views/components/apply_leave_view.dart';
import 'package:iroyal/app/modules/leave_summary/presentation/views/components/all_leave_request_view.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';

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
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          const AppbarSpacer(),
          _buildLeaveRequestSection(),
        ],
      ),
    );
  }

  Widget _buildTypesSection() {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(
        () => controller.isLoading.value
            ? ShimmerText(width: Get.width)
            : _buildTypeRow(
                "Year Leave Used",
                controller
                        .leaveModelRes()
                        .data!
                        .yearlyLeaveCount!
                        .used!
                        .toDouble() /
                    10,
                "${controller.leaveModelRes().data!.yearlyLeaveCount!.used!}/${controller.leaveModelRes().data!.yearlyLeaveCount!.max!}",
              ),
      ),
    );
  }

  Widget _buildTypeRow(String type, double value, String ratio) {
    return Row(
      children: [
        Text(type, style: TS.bodyMedium),
        10.horizontalSpace,
        Expanded(
          child: LinearProgressIndicator(
            color: primary,
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
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLeaveRequestHeader(),
          25.verticalSpace,
          _buildTypesSection(),
          25.verticalSpace,
          _buildSearch(),
          20.verticalSpace,
          _buildAllLeaveRequestView(),
          20.verticalSpace,
          controller.userData.value.position != 'Staff'
              ? _buildLeaveRequestTabViews()
              : emptyBox
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Obx(
      () => EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: InputPrimary(
          controller: controller.search,
          label: '',
          hint: 'Search',
          onChanged: controller.onChanged,
          color: white,
          outlineColor: primary,
          prefixIcon: _buildPrefixIcon(),
          suffixIcon: _buildSuffixIcon(),
        ),
      ),
    );
  }

  Widget _buildLeaveRequestHeader() {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Leave Request', style: TS.titleMedium),
          Obx(
            () => ButtonPrimary(
              enable: controller
                      .leaveModelRes()
                      .data!
                      .yearlyLeaveCount!
                      .remaining! >
                  0,
              borderRadius: Corners.xxl,
              margin: REdgeInsets.only(top: 5),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: controller
                          .leaveModelRes()
                          .data!
                          .yearlyLeaveCount!
                          .remaining ==
                      0
                  ? grey
                  : urgentColor,
              borderSide: BorderSide(
                  color: controller
                              .leaveModelRes()
                              .data!
                              .yearlyLeaveCount!
                              .remaining ==
                          0
                      ? grey
                      : urgentColor),
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
          ),
        ],
      ),
    );
  }

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
                  Tab(text: 'Need Approval'),
                ],
              ),
            ),
          )
        : AllLeaveRequestView(controller: controller);
  }

  Widget _buildLeaveRequestTabViews() {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: TabBarView(
        controller: controller.tabController,
        children: [
          AllLeaveRequestView(controller: controller),
          AllApprovalRequestView(controller: controller),
        ],
      ),
    );
  }

  Widget _buildPrefixIcon() {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SvgPicture.asset(
        'assets/icons/ic_search.svg',
        width: 20.w,
        height: 20.w,
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    final valueListener = controller.valueListener.value;
    return valueListener.isNotEmpty
        ? IconButton(
            onPressed: controller.clear,
            icon: const Icon(Icons.clear),
          )
        : null;
  }
}
