import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/leave_summary/presentation/controllers/leave_summary_controller.dart';
import 'package:iroyal/app/modules/leave_summary/presentation/views/components/all_permit_request_view.dart';
import 'package:iroyal/app/modules/leave_summary/presentation/views/components/create_permit_request_view.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/padding.dart';

class PermitView extends GetView<LeaveSummaryController> {
  const PermitView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leadingWidth: 45,
        iconTheme: IconThemeData(color: white, size: 18.w),
        leading: InkWell(
          onTap: () {
            controller.selectedPermitType.value = '';
            controller.selectedPermitTypeCode.value = '';
            controller.selectedStartTimePermitFormatted.value = '';
            controller.selectedEndTimePermitFormatted.value = '';
            controller.reasonPermit.value = '';
            controller.multiDatePickerValueleaveRequestWithDefaultValue.clear();
            controller.selectedStartDatePermit.value = DateTime(0);
            controller.selectedEndDatePermit.value = DateTime(0);
            controller.selectedStartTime.value = TimeOfDay(hour: 0, minute: 0);
            controller.selectedEndTime.value = TimeOfDay(hour: 0, minute: 0);

            Get.back();
          },
          child: Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: false,
        title: Text(
          'Permit Request',
          style: TS.titleSmall.copyWith(
            color: white,
          ),
        ),
        backgroundColor: primary,
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
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
                  controller: controller.tabPermitController,
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
                    Tab(text: 'Create Form'),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: Get.height,
              width: Get.width,
              child: TabBarView(
                controller: controller.tabPermitController,
                children: [
                  AllPermitRequestView(controller: controller),
                  CreatePermitRequestView(controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
