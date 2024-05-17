import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iroyal/app/modules/detail_tasks/views/components/tab_subtask_view.dart';
import 'package:iroyal/app/modules/tasks/presentation/views/components/shared/linear_progress.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/others/coming_soon.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import 'package:readmore/readmore.dart';

import '../controllers/detail_tasks_controller.dart';

class DetailTasksView extends GetView<DetailTasksController> {
  const DetailTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return DetailTasksViewImpl(controller: controller);
  }
}

class DetailTasksViewImpl extends StatelessWidget {
  const DetailTasksViewImpl({
    super.key,
    required this.controller,
  });

  final DetailTasksController controller;

  @override
  Widget build(BuildContext context) {
    return PageBase(
      title: 'Detail Task',
      child: SingleChildScrollView(
        child: EPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
              const AppbarSpacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Mobile Application Design',
                      style:
                          TS.titleMedium.copyWith(color: primary, fontSize: 18),
                    ),
                  ),
                  Container(
                    width: 95.w,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(24),
                      ),
                      color: Colors.blue.withOpacity(0.3),
                    ),
                    child: Center(
                      child: Text(
                        'To-Do',
                        style: TS.bodyMedium.copyWith(
                          color: Colors.blue.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              ReadMoreText(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                style: TS.bodyMedium.copyWith(color: greyText),
                trimMode: TrimMode.Line,
                trimLines: 2,
                colorClickableText: primary,
                trimCollapsedText: ' Show more',
                trimExpandedText: '  Show less',
                moreStyle: TS.bodyMedium
                    .copyWith(color: primary, fontWeight: FontWeight.w600),
                lessStyle: TS.bodyMedium
                    .copyWith(color: primary, fontWeight: FontWeight.w600),
              ),
              30.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TEAMS',
                        style: TS.bodyMedium.copyWith(color: greyText),
                      ),
                      EPadding(
                        padding: const EdgeInsets.only(left: 8, top: 10),
                        child: Row(
                          children: [
                            Row(
                              children: [
                                for (int i = 0;
                                    i < controller.randomImages.length;
                                    i++)
                                  Align(
                                    widthFactor: 0.5,
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 22,
                                        backgroundImage: NetworkImage(
                                          controller.randomImages[i],
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                            20.horizontalSpace,
                            CircleAvatar(
                              backgroundColor: greyIcon.withOpacity(0.2),
                              radius: 20,
                              child: const Center(child: Icon(Icons.add)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EST. DATE',
                        style: TS.bodyMedium.copyWith(color: greyText),
                      ),
                      EPadding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          '17, May 2024',
                          style: TS.bodyLarge.copyWith(color: primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              20.verticalSpace,
              const LinearProgress(
                percentageText: '10%',
                percentageColor: red,
                valueLinear: 0.1,
                progressColor: Colors.red,
              ),
              30.verticalSpace,
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: grey),
                  borderRadius: BorderRadius.circular(Corners.slg),
                  color: white,
                ),
                child: TabBar(
                  // tabAlignment: TabAlignment.start,
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
                    Tab(text: 'Sub Task'),
                    Tab(text: 'File'),
                    Tab(text: 'Comment')
                  ],
                ),
              ),
              20.verticalSpace,
              Container(
                padding: REdgeInsets.symmetric(horizontal: 14),
                width: Get.width,
                height: 625.h,
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller.tabController,
                  children: [
                    TabSubTaskView(controller: controller),
                    const ComingSoonTabView(),
                    const ComingSoonTabView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
