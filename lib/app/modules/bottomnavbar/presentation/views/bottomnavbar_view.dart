import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/attendance/presentation/views/attendance_view.dart';
import 'package:MyRoyal/app/modules/bottomnavbar/presentation/views/components/custom_bottomnavbar.dart';
import 'package:MyRoyal/app/modules/home/presentation/views/home_view.dart';
import 'package:MyRoyal/app/modules/settings/presentation/views/settings_view.dart';
import 'package:MyRoyal/base/config/app_constants.dart';
import 'package:MyRoyal/base/widgets/page_base.dart';

import '../controllers/bottomnavbar_controller.dart';

class BottomnavbarView extends GetView<BottomnavbarController> {
  const BottomnavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBase(
      appBar: emptyBox,
      showBackground: false,
      centeredTitle: true,
      showIconBack: false,
      resizeInsetsBottom: false,
      bottomBarDecoration: const BoxDecoration(color: Colors.transparent),
      bottomBar: Obx(
        () => CustomButtomBar(
          listBottomNav: List.generate(
            controller.bottomnavbarMenu.length,
            (index) => Expanded(
              child: IconTab(
                icon: controller.isSelected(index)
                    ? controller.bottomnavbarMenu[index].selectedIcon
                    : controller.bottomnavbarMenu[index].icon,
                name: controller.isSelected(index)
                    ? controller.bottomnavbarMenu[index].name
                    : null,
                isSelected: controller.isSelected(index),
                onTap: () => controller.selectMenu(index),
              ),
            ),
          ),
        ),
      ),
      child: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: List.generate(
            controller.bottomnavbarMenu.length,
            (index) => controller.loadedPages.contains(index)
                ? _buildPage(index)
                : const SizedBox(),
          ),
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const HomeView();

      case 1:
        return const AttendanceView();

      case 2:
        return const SettingsView();

      default:
        return const SizedBox();
    }
  }
}
