import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:iroyal/app/modules/my_teams/presentation/views/components/customize_pie_chart1.dart';
import 'package:iroyal/app/modules/my_teams/presentation/views/components/customize_pie_chart2.dart';
import 'package:iroyal/app/modules/my_teams/presentation/views/components/expansion_tile.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/others/no_result_widget.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';

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
              EPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 162.w,
                            height: 118.h,
                            margin: EdgeInsets.only(top: 5.h),
                            decoration: const ShapeDecoration(
                              color: primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Average Age',
                                  style: TS.bodySmall.copyWith(
                                    color: white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                10.verticalSpace,
                                Text(
                                  controller.myTeamsData().averageAge == 0.0
                                      ? '0'
                                      : controller
                                          .myTeamsData()
                                          .averageAge
                                          .ceilToDouble()
                                          .toString()
                                          .substring(0, 2),
                                  style: TS.bodySmall.copyWith(color: white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          5.verticalSpace,
                          Material(
                            color: white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              side: BorderSide(
                                color: primary,
                              ),
                            ),
                            child: EPadding(
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 16,
                                left: 8,
                                right: 8,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Task Compliance Ratio',
                                    style: TS.bodySmall.copyWith(
                                      color: primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  15.verticalSpace,
                                  const SizedBox(
                                    height: 125,
                                    width: 100,
                                    child: PieChartSample2(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    4.horizontalSpace,
                    Expanded(
                      child: Column(
                        children: [
                          Material(
                            color: white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              side: BorderSide(
                                color: primary,
                              ),
                            ),
                            child: EPadding(
                              padding: const EdgeInsets.only(
                                bottom: 8,
                                top: 4,
                                left: 10,
                                right: 10,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Male-Female Comparison',
                                    style: TS.bodySmall.copyWith(
                                      color: primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  15.verticalSpace,
                                  SizedBox(
                                    height: 125,
                                    width: 90,
                                    child: PieChartSample1(
                                      titleSection1:
                                          '${controller.myTeamsData().genderDistribution.male.round()}%',
                                      titleSection2:
                                          '${controller.myTeamsData().genderDistribution.female.round()}%',
                                      valueSection1: controller
                                          .myTeamsData()
                                          .genderDistribution
                                          .male,
                                      valueSection2: controller
                                          .myTeamsData()
                                          .genderDistribution
                                          .female,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          5.verticalSpace,
                          Container(
                            width: 175.w,
                            height: 114.h,
                            decoration: const ShapeDecoration(
                              color: primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Immediate Action Required Task',
                                  style: TS.bodySmall.copyWith(
                                    color: white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                10.verticalSpace,
                                Text(
                                  '31.00',
                                  style: TS.bodySmall.copyWith(color: white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              EPadding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 12,
                  top: 20,
                  bottom: 8,
                ),
                child: InputPrimary(
                  controller: controller.searchE,
                  key: const Key('searchUser'),
                  label: '',
                  hint: 'Search',
                  onChanged: controller.onChanged,
                  prefixIcon: Padding(
                    padding: REdgeInsets.symmetric(horizontal: 12),
                    child: SvgPicture.asset(
                      'assets/icons/ic_search.svg',
                      width: 20.w,
                      height: 20.w,
                    ),
                  ),
                ),
              ),
              controller.filteredList.isNotEmpty
                  ? SizedBox(
                      height: 400,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: controller.myTeamsData().children.length,
                        itemBuilder: (context, index) {
                          final String name =
                              controller.myTeamsData().children[index].fullName;
                          final split = name.split(' ');
                          final firstChar =
                              split.first.substring(0, 1).toUpperCase();
                          final secondChar =
                              split.last.substring(0, 1).toUpperCase();
                          return ExpansionTileControllerApp(
                            imgAvatar: firstChar + secondChar,
                            username: controller
                                .myTeamsData()
                                .children[index]
                                .fullName,
                            departement: controller
                                .myTeamsData()
                                .children[index]
                                .job
                                .department,
                            email: controller
                                .myTeamsData()
                                .children[index]
                                .job
                                .workEmail,
                            children: controller
                                .myTeamsData()
                                .children[index]
                                .children,
                          );
                        },
                      ),
                    )
                  : SizedBox(height: 400.h, child: const NoResultWidget())
            ],
          ),
        ),
      ),
    );
  }
}
