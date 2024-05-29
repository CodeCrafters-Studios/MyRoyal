import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iroyal/app/modules/attendance/views/attendance_view.dart';
import 'package:iroyal/app/modules/bottomnavbar/presentation/views/components/custom_bottomnavbar.dart';
import 'package:iroyal/app/modules/home/presentation/views/home_view.dart';
import 'package:iroyal/app/modules/settings/presentation/views/settings_view.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/widgets/page_base.dart';

import '../controllers/bottomnavbar_controller.dart';

class BottomnavbarView extends GetView<BottomnavbarController> {
  const BottomnavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PageBase(
        appBar: emptyBox,
        showBackground: false,
        centeredTitle: true,
        showIconBack: false,
        resizeInsetsBottom: false,
        bottomBar: CustomButtomBar(
          listBottomNav: List.generate(
            controller.bottomnavbarMenu.length,
            (index) => Expanded(
              child: IconTab(
                icon: controller.bottomnavbarMenu[index].icon,
                name: controller.bottomnavbarMenu[index].name,
                isSelected: controller.isSelected(index),
                onTap: () {
                  controller.selectMenu(index);
                  controller.tabController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          ),
        ),
        child: PageView(
          controller: controller.tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            HomeView(),
            AttendanceView(),
            SettingsView(),
          ],
        ),
      ),
    );
  }
}
