import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/tasks/presentation/controllers/tasks_controller.dart';
import 'package:MyRoyal/app/modules/tasks/presentation/views/components/tabs/tab_all_tasks.dart';
import 'package:MyRoyal/app/modules/tasks/presentation/views/components/tabs/tab_completed.dart';
import 'package:MyRoyal/app/modules/tasks/presentation/views/components/tabs/tab_in_progress.dart';
import 'package:MyRoyal/app/modules/tasks/presentation/views/components/tabs/tab_todo.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/appbar_spacer.dart';
import 'package:MyRoyal/base/widgets/page_base.dart';

class AllTasksView extends StatelessWidget {
  const AllTasksView({super.key, required this.controller});

  final TasksController controller;

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'All Tasks',
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppbarSpacer(),
            _buildTabBar(),
            20.verticalSpace,
            _buildTabBarView(),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(100.h),
      child: Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: grey, width: 2.0),
              ),
            ),
          ),
          TabBar(
            tabAlignment: TabAlignment.center,
            padding: EdgeInsets.zero,
            indicatorSize: TabBarIndicatorSize.tab,
            controller: controller.tabController,
            physics: const NeverScrollableScrollPhysics(),
            labelStyle: TS.bodyMedium,
            labelColor: black,
            indicatorColor: black,
            unselectedLabelColor: greyText,
            isScrollable: true,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'To-Do'),
              Tab(text: 'In-Progress'),
              Tab(text: 'Completed'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    return Container(
      padding: REdgeInsets.fromLTRB(14, 0, 14, 120),
      width: Get.width,
      height: Get.height,
      child: TabBarView(
        controller: controller.tabController,
        children: [
          TabAllTasks(controller: controller),
          TabToDoTasks(controller: controller),
          TabInProgressTasks(controller: controller),
          TabCompletedTasks(controller: controller),
        ],
      ),
    );
  }
}
