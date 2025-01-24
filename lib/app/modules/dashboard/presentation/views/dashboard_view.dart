import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/dashboard/presentation/views/widgets/dashboard_card.dart';
import 'package:iroyal/app/modules/dashboard/presentation/views/widgets/detail_late_check_in_view.dart';
import 'package:iroyal/app/modules/dashboard/presentation/views/widgets/detail_permit_request_view.dart';
import 'package:iroyal/app/modules/dashboard/presentation/views/widgets/detail_special_leave_view.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/others/coming_soon.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'Dashboard',
      child: SingleChildScrollView(
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AppbarSpacer(),
              controller.isLoading.value ? _buildLoadingUI() : _buildLoadedUI(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingUI() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildDashboardCard(),
          25.verticalSpace,
          // PieChart(
          //   chartRadius: 150.r,
          //   centerWidget: Text(
          //     controller.remainingLeave.toString(),
          //     style: TS.headlineLarge,
          //   ),
          //   legendOptions: LegendOptions(
          //     legendTextStyle: TS.bodyLarge,
          //     legendPosition: LegendPosition.bottom,
          //     showLegendsInRow: true,
          //   ),
          //   dataMap: const {"balance": 0.0, "used": 0.0},
          //   chartType: ChartType.ring,
          //   baseChartColor: black.withOpacity(0.15),
          //   colorList: controller.colorList,
          //   chartValuesOptions: ChartValuesOptions(
          //     showChartValuesInPercentage: false,
          //     decimalPlaces: 0,
          //     showChartValuesOutside: true,
          //     showChartValueBackground: false,
          //     chartValueStyle: TS.titleMedium.copyWith(color: black),
          //   ),
          //   totalValue: controller.remainingLeave.value.toDouble(),
          // ),
        ],
      ),
    );
  }

  Widget _buildLoadedUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDashboardSection(),
        controller.hasTeams.value ? 20.verticalSpace : emptyBox,
        // controller.hasTeams.value ? _buildMyTeamsSection() : emptyBox,
      ],
    );
  }

  Widget _buildDashboardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDashboardCard(),
        10.verticalSpace,
        // EPadding(
        //   padding: const EdgeInsets.only(left: 14),
        //   child: Text('Leaves Summary', style: TS.titleMedium),
        // ),
        // 25.verticalSpace,
        // Obx(
        //   () => PieChart(
        //     chartRadius: 150.r,
        //     centerWidget: Text(
        //       controller.dashboardData().data!.leaveBalance!.used.toString(),
        //       style: TS.headlineLarge,
        //     ),
        //     legendOptions: LegendOptions(
        //       legendTextStyle: TS.bodyLarge,
        //       legendPosition: LegendPosition.bottom,
        //       showLegendsInRow: true,
        //     ),
        //     dataMap: controller.dashboardData().data!.leaveBalance != null
        //         ? {
        //             "balance": controller
        //                 .dashboardData()
        //                 .data!
        //                 .leaveBalance!
        //                 .balance!
        //                 .toDouble(),
        //             "used": controller
        //                 .dashboardData()
        //                 .data!
        //                 .leaveBalance!
        //                 .used!
        //                 .toDouble(),
        //           }
        //         : {"balance": 8.0, "used": 0.0},
        //     chartType: ChartType.ring,
        //     baseChartColor: black.withOpacity(0.15),
        //     colorList: controller.colorList,
        //     chartValuesOptions: ChartValuesOptions(
        //       showChartValuesInPercentage: false,
        //       decimalPlaces: 0,
        //       showChartValuesOutside: true,
        //       showChartValueBackground: false,
        //       chartValueStyle: TS.titleMedium.copyWith(color: black),
        //     ),
        //     totalValue: controller
        //             .dashboardData()
        //             .data!
        //             .leaveBalance!
        //             .balance!
        //             .toDouble() +
        //         controller.dashboardData().data!.leaveBalance!.used!.toDouble(),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildDashboardCard() {
    final leaveSummaryData = controller.dashboardData().data!.leaveSummary!;
    final permitData = controller.dashboardData().data!.permit!;

    return Column(
      children: [
        DashboardCard(
          title: 'Special Leave\nRequests',
          value: leaveSummaryData.specialLeaves.toString(),
          totalValue: '',
          progressLinearValue: 0,
          textColor: secondary,
          progressLinearColor: secondary,
          valueColor: secondary,
          backgroundImage: 'assets/images/img_bg_special_leave.png',
          iconAsset: 'assets/icons/ic_special_leaves.svg',
          isLateCard: true,
          onTap: () => Get.to(() => DetailSpecialLeaveView()),
          // onTap: () => Get.to(() => ComingSoonScreen()),
        ),
        5.verticalSpace,
        DashboardCard(
          title: 'Permit\nRequest',
          value: permitData.count.toString(),
          totalValue: '',
          progressLinearValue: 0,
          textColor: primary20,
          progressLinearColor: primary20,
          valueColor: primary20,
          backgroundImage: 'assets/images/img_bg_request_leave.png',
          iconAsset: 'assets/icons/ic_request_leave.svg',
          isLateCard: true,
          onTap: () => Get.to(() => DetailPermitRequestView()),
        ),
        5.verticalSpace,
        DashboardCard(
          title: 'Late\nCheck-In',
          value: leaveSummaryData.late.toString(),
          totalValue: '',
          progressLinearValue: 0,
          textColor: errorColor,
          progressLinearColor: errorColor,
          valueColor: errorColor,
          backgroundImage: 'assets/images/img_late_check_in.png',
          iconAsset: 'assets/icons/ic_late_check_in.svg',
          isLateCard: true,
          onTap: () => Get.to(() => DetailLateCheckInView()),
        ),
      ],
    );
  }

  // -- My Teams Section
  // Widget _buildMyTeamsSection() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text('My Teams Summary', style: TS.titleMedium),
  //       20.verticalSpace,
  //       Align(
  //         alignment: Alignment.center,
  //         child: _buildContainer(
  //           'Average Age',
  //           controller.myTeamsData().averageAge == 0.0
  //               ? '0'
  //               : controller
  //                   .myTeamsData()
  //                   .averageAge
  //                   .round()
  //                   .toString()
  //                   .substring(0, 2),
  //           175,
  //           80,
  //         ),
  //       ),
  //       20.verticalSpace,
  //       _buildGenderRatio(),
  //     ],
  //   );
  // }
  // Widget _buildContainer(
  //     String title, String value, double width, double height) {
  //   return Container(
  //     width: width.w,
  //     height: height.h,
  //     decoration: BoxDecoration(
  //       color: primary,
  //       borderRadius: BorderRadius.circular(Corners.lsm),
  //     ),
  //     child: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Text(
  //             title,
  //             style: TS.bodySmall
  //                 .copyWith(color: white, fontWeight: FontWeight.bold),
  //             textAlign: TextAlign.center,
  //           ),
  //           10.verticalSpace,
  //           Text(
  //             value,
  //             style: TS.bodySmall.copyWith(color: white),
  //             textAlign: TextAlign.center,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  // Widget _buildGenderRatio() {
  //   return Column(
  //     children: [
  //       Text(
  //         'Gender Comparison',
  //         style: TS.bodySmall
  //             .copyWith(color: primary, fontWeight: FontWeight.bold),
  //         textAlign: TextAlign.center,
  //       ),
  //       20.verticalSpace,
  //       PieChart(
  //         chartRadius: 150.r,
  //         centerWidget: Text(
  //           controller.totalValueGender.value.toString(),
  //           style: TS.headlineLarge,
  //         ),
  //         legendOptions: LegendOptions(
  //           legendTextStyle: TS.bodyLarge,
  //           legendPosition: LegendPosition.bottom,
  //           showLegendsInRow: true,
  //         ),
  //         dataMap: controller.getGenderDistributionMap(),
  //         chartType: ChartType.ring,
  //         baseChartColor: black.withOpacity(0.15),
  //         colorList: controller.colorGenderList,
  //         chartValuesOptions: ChartValuesOptions(
  //           showChartValuesInPercentage: false,
  //           decimalPlaces: 0,
  //           showChartValuesOutside: true,
  //           showChartValueBackground: false,
  //           chartValueStyle: TS.titleMedium.copyWith(color: black),
  //         ),
  //         totalValue: controller.totalValueGender.value,
  //       ),
  //     ],
  //   );
  // }
}
