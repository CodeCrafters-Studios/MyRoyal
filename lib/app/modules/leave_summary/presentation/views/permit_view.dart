import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/leave_summary/presentation/controllers/leave_summary_controller.dart';
import 'package:MyRoyal/app/modules/leave_summary/presentation/views/components/all_permit_request_view.dart';
import 'package:MyRoyal/app/modules/leave_summary/presentation/views/components/create_permit_request_view.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/padding.dart';

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
          onTap: () => controller.clearPermitRequest(),
          child: Icon(Icons.arrow_back_ios_new),
        ),
        centerTitle: false,
        title: Text(
          'Pengajuan Izin',
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
                  labelColor: white,
                  labelStyle: TS.bodyMedium.copyWith(color: white),
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
