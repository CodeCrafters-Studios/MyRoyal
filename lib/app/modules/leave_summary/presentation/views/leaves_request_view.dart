import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/leave_summary/presentation/controllers/leave_summary_controller.dart';
import 'package:MyRoyal/app/modules/leave_summary/presentation/views/components/all_leave_request_view.dart';
import 'package:MyRoyal/app/modules/leave_summary/presentation/views/components/create_leave_request_view.dart';
import 'package:MyRoyal/app/modules/leave_summary/presentation/views/components/no_leaves_available.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/padding.dart';

class LeavesRequestView extends GetView<LeaveSummaryController> {
  const LeavesRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leadingWidth: 45,
        iconTheme: IconThemeData(color: white, size: 18.w),
        leading: InkWell(
          onTap: () {
            controller.clearSubtituteEmployee();
            controller.multiDatePickerValueleaveRequestWithDefaultValue.clear();
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: false,
        title: Text(
          'Pengajuan Cuti',
          style: TS.titleSmall.copyWith(
            color: white,
          ),
        ),
        backgroundColor: primary,
        actions: [
          EPadding(
            padding: EdgeInsets.only(right: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Sisa Cuti',
                  style: TS.bodySmall.copyWith(
                    color: white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${controller.leaveModelRes().data!.yearlyLeaveCount!.remaining.toString()} left',
                  style: TS.bodySmall.copyWith(
                    color: urgentColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            EPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                  splashBorderRadius: BorderRadius.circular(Corners.xxl),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: TS.bodyMedium.copyWith(color: white),
                  labelColor: white,
                  unselectedLabelStyle: TS.bodyMedium.copyWith(color: primary),
                  unselectedLabelColor: primary,
                  tabs: const [
                    Tab(text: 'Semua'),
                    Tab(text: 'Buat Pengajuan'),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Get.height * .8,
              width: Get.width,
              child: TabBarView(
                controller: controller.tabLeaveController,
                children: [
                  AllLeaveRequestView(controller: controller),
                  controller
                              .leaveModelRes()
                              .data!
                              .yearlyLeaveCount!
                              .remaining ==
                          0
                      ? NoLeavesAvailable()
                      : CreateLeaveRequestView(controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
