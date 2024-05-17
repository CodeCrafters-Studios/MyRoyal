import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/bottomnavbar/domain/entities/bottomnavbar_menu.dart';

class BottomnavbarController extends GetxController {
  final tabController = PageController();
  RxInt currentIndex = 0.obs;

  List<BottomnavbarMenu> bottomnavbarMenu = <BottomnavbarMenu>[
    BottomnavbarMenu(name: 'Home', icon: 'assets/icons/ic_tab_home.svg'),
    BottomnavbarMenu(name: 'Settings', icon: 'assets/icons/ic_settings.svg'),
  ];

  bool isSelected(int index) => currentIndex.value == index;

  void selectMenu(int index) {
    currentIndex.value = index;
  }
}
