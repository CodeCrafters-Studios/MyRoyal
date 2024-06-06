import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iroyal/app/modules/attendance/views/components/attendance_card.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:iroyal/app/modules/my_teams/presentation/views/components/customize_pie_chart2.dart';
import 'package:iroyal/app/modules/my_teams/presentation/views/components/indicator.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import 'package:pie_chart/pie_chart.dart';
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
        child: EPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const AppbarSpacer(),
                controller.isLoading.value
                    ? _buildLoadingUI()
                    : _buildLoadedUI(),
              ],
            ),
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
          Align(
            alignment: Alignment.topLeft,
            child: ShimmerText(width: 150.w),
          ),
          20.verticalSpace,
          _buildContainer('', '', 500.w, 250.h),
          20.verticalSpace,
          Align(
            alignment: Alignment.topLeft,
            child: ShimmerText(width: 180.w),
          ),
          20.verticalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildContainer('Average Age', '0', 175, 80),
              20.verticalSpace,
              _buildContainer('', '', 500.w, 250.h),
            ],
          ),
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
        controller.hasTeams.value ? _buildMyTeamsSection() : emptyBox,
        20.verticalSpace,
        _buildTaskComplianceRatio(),
      ],
    );
  }

  Widget _buildDashboardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Leaves Summary', style: TS.titleMedium),
        20.verticalSpace,
        _buildAttendanceGrid(),
        20.verticalSpace,
        PieChart(
          chartRadius: 150.r,
          centerWidget: Text(
            controller.remainingLeave.toString(),
            style: TS.headlineLarge,
          ),
          legendOptions: LegendOptions(
            legendTextStyle: TS.bodyLarge,
            legendPosition: LegendPosition.bottom,
            showLegendsInRow: true,
          ),
          dataMap: controller.dataMap,
          chartType: ChartType.ring,
          baseChartColor: black.withOpacity(0.15),
          colorList: controller.colorList,
          chartValuesOptions: ChartValuesOptions(
            showChartValuesInPercentage: false,
            decimalPlaces: 0,
            showChartValuesOutside: true,
            showChartValueBackground: false,
            chartValueStyle: TS.titleMedium.copyWith(color: black),
          ),
          totalValue: controller.remainingLeave.value.toDouble(),
        ),
      ],
    );
  }

  Widget _buildAttendanceGrid() {
    return GridView.count(
      padding: EdgeInsets.zero,
      childAspectRatio: 2.5,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      shrinkWrap: true,
      children: const [
        AttendanceCard(
          backgroundColor: primary,
          title: '02',
          subTitle: 'Special Leaves',
        ),
        AttendanceCard(
          backgroundColor: secondary70,
          title: '05',
          subTitle: 'Absents',
        ),
        AttendanceCard(
          backgroundColor: red,
          title: '0',
          subTitle: 'Late in',
        ),
        AttendanceCard(
          backgroundColor: Colors.orange,
          title: '08',
          subTitle: 'Leaves',
        ),
      ],
    );
  }

  Widget _buildMyTeamsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('My Teams Summary', style: TS.titleMedium),
        20.verticalSpace,
        Align(
          alignment: Alignment.center,
          child: _buildContainer(
            'Average Age',
            controller.myTeamsData().averageAge == 0.0
                ? '0'
                : controller
                    .myTeamsData()
                    .averageAge
                    .round()
                    .toString()
                    .substring(0, 2),
            175,
            80,
          ),
        ),
        20.verticalSpace,
        _buildGenderRatio(),
      ],
    );
  }

  Widget _buildContainer(
      String title, String value, double width, double height) {
    return Container(
      width: width.w,
      height: height.h,
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(Corners.lsm),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TS.bodySmall
                  .copyWith(color: white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            10.verticalSpace,
            Text(
              value,
              style: TS.bodySmall.copyWith(color: white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskComplianceRatio() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Task Compliance Ratio', style: TS.titleMedium),
        20.verticalSpace,
        Align(
          alignment: Alignment.center,
          child: _buildContainer(
            'Immediate Action\nRequired Task',
            '20',
            175,
            114,
          ),
        ),
        5.verticalSpace,
        Column(
          children: [
            SizedBox(
              height: 200.r,
              child: const PieChartSample2(),
            ),
            15.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Indicator(
                  color: Colors.blue,
                  text: 'Task 1',
                  isSquare: true,
                ),
                12.horizontalSpace,
                const Indicator(
                  color: Colors.purple,
                  text: 'Task 2',
                  isSquare: true,
                ),
              ],
            ),
            5.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Indicator(
                  color: Colors.red,
                  text: 'Task 3',
                  isSquare: true,
                ),
                10.horizontalSpace,
                const Indicator(
                  color: Colors.green,
                  text: 'Task 4',
                  isSquare: true,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderRatio() {
    return Column(
      children: [
        Text(
          'Gender Comparison',
          style: TS.bodySmall
              .copyWith(color: primary, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        20.verticalSpace,
        PieChart(
          chartRadius: 150.r,
          centerWidget: Text(
            controller.totalValueGender.value.toString(),
            style: TS.headlineLarge,
          ),
          legendOptions: LegendOptions(
            legendTextStyle: TS.bodyLarge,
            legendPosition: LegendPosition.bottom,
            showLegendsInRow: true,
          ),
          dataMap: controller.getGenderDistributionMap(),
          chartType: ChartType.ring,
          baseChartColor: black.withOpacity(0.15),
          colorList: controller.colorGenderList,
          chartValuesOptions: ChartValuesOptions(
            showChartValuesInPercentage: false,
            decimalPlaces: 0,
            showChartValuesOutside: true,
            showChartValueBackground: false,
            chartValueStyle: TS.titleMedium.copyWith(color: black),
          ),
          totalValue: controller.totalValueGender.value,
        ),
      ],
    );
  }
}
