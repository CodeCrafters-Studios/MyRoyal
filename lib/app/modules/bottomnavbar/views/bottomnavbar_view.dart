import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iroyal/app/modules/bottomnavbar/views/components/custom_bottomnavbar.dart';
import 'package:iroyal/app/modules/home/presentation/views/home_view.dart';
import 'package:iroyal/app/modules/profile/views/profile_view.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/widgets/page_base.dart';

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
      bottomBar: CustomBottomNavBar(
        index: controller.switchTab,
      ),
      child: PageView(
        controller: controller.tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          HomeView(),
          ProfileView(),
        ],
      ),
    );
  }
}
