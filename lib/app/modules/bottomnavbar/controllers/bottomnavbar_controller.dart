import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class BottomnavbarController extends GetxController {
  final tabController = PageController();
  RxInt currentTab = 0.obs;

  void switchTab(int index) {
    currentTab(index);
    tabController.jumpToPage(index);
  }
}
