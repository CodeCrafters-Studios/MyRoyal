import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/tasks/controllers/tasks_controller.dart';
import 'package:iroyal/app/modules/tasks/views/components/tabs/tab_all_tasks.dart';
import 'package:iroyal/app/modules/tasks/views/components/tabs/tab_completed.dart';
import 'package:iroyal/app/modules/tasks/views/components/tabs/tab_in_progress.dart';
import 'package:iroyal/app/modules/tasks/views/components/tabs/tab_todo.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';

class ViewAllTasksView extends StatelessWidget {
  const ViewAllTasksView({super.key, required this.controller});

  final TasksController controller;

  @override
  Widget build(BuildContext context) {
    return PageBase(
      title: 'All Tasks',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppbarSpacer(),
          _buildTabBar(),
          20.verticalSpace,
          _buildTabBarView(),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: grey),
          borderRadius: BorderRadius.circular(14),
          color: white,
        ),
        child: TabBar(
          tabAlignment: TabAlignment.start,
          padding: REdgeInsets.only(left: 2),
          isScrollable: true,
          controller: controller.tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: primary,
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelStyle: TS.bodyMedium.copyWith(color: white),
          unselectedLabelStyle: TS.bodyMedium.copyWith(color: primary),
          unselectedLabelColor: primary,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'To-Do'),
            Tab(text: 'In-Progress'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBarView() {
    return Container(
      padding: REdgeInsets.symmetric(horizontal: 14),
      width: Get.width,
      height: 625.h,
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
