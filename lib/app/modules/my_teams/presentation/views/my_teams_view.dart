import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/my_teams/presentation/views/components/customize_pie_chart1.dart';
import 'package:iroyal/app/modules/my_teams/presentation/views/components/customize_pie_chart2.dart';
import 'package:iroyal/app/modules/my_teams/presentation/views/components/expansion_tile.dart';
import 'package:iroyal/app/modules/my_teams/presentation/views/components/indicator.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';
import 'package:iroyal/base/widgets/others/no_result_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/my_teams_controller.dart';

class MyTeamsView extends GetView<MyTeamsController> {
  const MyTeamsView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'My Teams',
      child: SingleChildScrollView(
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const AppbarSpacer(),
              controller.isLoading.value ? _buildLoadingUI() : _buildLoadedUI(),
              _buildSearchInput(),
              _buildListView(),
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
      child: EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  _buildContainer('Average Age', '0', 175, 114),
                  5.verticalSpace,
                  _buildTaskComplianceRatio(),
                ],
              ),
            ),
            4.horizontalSpace,
            Expanded(
              child: Column(
                children: [
                  _buildTaskComplianceRatio(),
                  5.verticalSpace,
                  _buildContainer(
                      'Immediate Action Required Task', '', 175, 114),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedUI() {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              children: [
                _buildContainer(
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
                5.verticalSpace,
                _buildTaskComplianceRatio(),
              ],
            ),
          ),
          4.horizontalSpace,
          Expanded(
            child: Column(
              children: [
                _buildMaleFemaleRatio(),
                5.verticalSpace,
                _buildContainer(
                    'Immediate Action\nRequired Task', '20', 175, 114),
              ],
            ),
          ),
        ],
      ),
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
    return Material(
      color: white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Corners.smRadius),
        side: const BorderSide(color: primary),
      ),
      child: EPadding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          children: [
            Text(
              'Task Compliance Ratio',
              style: TS.bodySmall
                  .copyWith(color: primary, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            15.verticalSpace,
            SizedBox(
              height: 125.h,
              width: 100.w,
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
      ),
    );
  }

  Widget _buildMaleFemaleRatio() {
    return Material(
      color: white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Corners.smRadius),
        side: const BorderSide(color: primary),
      ),
      child: EPadding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          children: [
            Text(
              'Gender Comparison',
              style: TS.bodySmall
                  .copyWith(color: primary, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            5.verticalSpace,
            SizedBox(
              height: 128.h,
              width: 100.w,
              child: PieChartSample1(
                titleSection1:
                    '${controller.myTeamsData().genderDistribution.male.round()}%',
                titleSection2:
                    '${controller.myTeamsData().genderDistribution.female.round()}%',
                valueSection1: controller.myTeamsData().genderDistribution.male,
                valueSection2:
                    controller.myTeamsData().genderDistribution.female,
              ),
            ),
            10.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Indicator(
                  color: Colors.blue,
                  text: 'Male',
                  isSquare: true,
                ),
                10.horizontalSpace,
                const Indicator(
                  color: Colors.purple,
                  text: 'Female',
                  isSquare: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchInput() {
    return EPadding(
      padding: const EdgeInsets.only(left: 16, top: 15, right: 16),
      child: InputPrimary(
        controller: controller.searchE,
        key: const Key('searchUser'),
        label: '',
        hint: 'Search',
        onChanged: controller.onChanged,
        color: white,
        outlineColor: primary,
        prefixIcon: EPadding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SvgPicture.asset(
            'assets/icons/ic_search.svg',
            width: 20.w,
            height: 20.w,
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return controller.isLoading.value
        ? _buildLoadingList()
        : controller.filteredList.isNotEmpty
            ? _buildFilteredList()
            : SizedBox(
                height: 250.h,
                child: const NoResultWidget(),
              );
  }

  Widget _buildLoadingList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: SizedBox(
        height: 400.h,
        child: ListView.builder(
          padding: REdgeInsets.symmetric(horizontal: 4),
          itemCount: 10,
          itemBuilder: (context, index) {
            return const ExpansionTileControllerApp(
              imgAvatar: '',
              username: '',
              departement: '',
              email: '',
              children: [],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFilteredList() {
    return SizedBox(
      height: 400.h,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.filteredList.length,
        itemBuilder: (context, index) {
          final String name = controller.filteredList[index].fullName;
          final split = name.split(' ');
          final firstChar = split.first.substring(0, 1).toUpperCase();
          final secondChar = split.last.substring(0, 1).toUpperCase();
          return ExpansionTileControllerApp(
            imgAvatar: firstChar + secondChar,
            username: controller.filteredList[index].fullName,
            departement: controller.filteredList[index].job.position,
            email: controller.filteredList[index].job.workEmail,
            children: controller.filteredList[index].children,
          );
        },
      ),
    );
  }
}
