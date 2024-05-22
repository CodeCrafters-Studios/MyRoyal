import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iroyal/app/modules/detail_tasks/views/components/description_detail_task.dart';
import 'package:iroyal/app/modules/detail_tasks/views/components/header_detail_task.dart';
import 'package:iroyal/app/modules/detail_tasks/views/components/tabs/tab_subtask_view.dart';
import 'package:iroyal/app/modules/tasks/presentation/views/components/shared/linear_progress.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/others/coming_soon.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';

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
      showBackground: false,
      title: 'Detail Task',
      child: SingleChildScrollView(
        child: EPadding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            children: [
              const HeaderDetailTask(
                title: 'Mobile Application Design',
                status: 'To-Do',
                statusColor: Colors.blue,
                bgStatusColor: Colors.blue,
              ),
              10.verticalSpace,
              const DescriptionDetailTask(
                description:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
              ),
              30.verticalSpace,
              _buildTeamsAndDateSection(),
              20.verticalSpace,
              const LinearProgress(
                percentageText: '10%',
                percentageColor: red,
                valueLinear: 0.1,
                progressColor: Colors.red,
              ),
              30.verticalSpace,
              _buildTabSection(),
              20.verticalSpace,
              _buildTabViewSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamsAndDateSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTeamsSection(),
        _buildDateSection(),
      ],
    );
  }

  Widget _buildTeamsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('TEAMS', style: TS.bodyMedium.copyWith(color: greyText)),
        EPadding(
          padding: const EdgeInsets.only(left: 8, top: 10),
          child: Row(
            children: [
              ..._buildTeamAvatars(),
              SizedBox(width: 20.w),
              CircleAvatar(
                backgroundColor: greyIcon.withOpacity(0.2),
                radius: 20,
                child: const Center(child: Icon(Icons.add)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildTeamAvatars() {
    return [
      for (int i = 0; i < controller.randomImages.length; i++)
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
        ),
    ];
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('EST. DATE', style: TS.bodyMedium.copyWith(color: greyText)),
        EPadding(
          padding: const EdgeInsets.only(top: 10),
          child: Text('17, May 2024',
              style: TS.bodyLarge.copyWith(color: primary)),
        ),
      ],
    );
  }

  Widget _buildTabSection() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: grey),
        borderRadius: BorderRadius.circular(Corners.slg),
        color: white,
      ),
      child: TabBar(
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
          Tab(text: 'Comment'),
        ],
      ),
    );
  }

  Widget _buildTabViewSection() {
    return Container(
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
    );
  }
}
