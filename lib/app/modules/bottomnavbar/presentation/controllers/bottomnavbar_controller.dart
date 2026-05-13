import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/bottomnavbar/domain/entities/bottomnavbar_menu.dart';

class BottomnavbarController extends GetxController {
  RxInt currentIndex = 0.obs;

  final RxSet<int> loadedPages = <int>{0}.obs;

  List<BottomnavbarMenu> bottomnavbarMenu = <BottomnavbarMenu>[
    BottomnavbarMenu(
      name: 'Beranda',
      icon: 'assets/icons/ic_tab_home.svg',
      selectedIcon: 'assets/icons/ic_tab_home_selected.svg',
    ),
    BottomnavbarMenu(
      name: 'Kehadiran',
      icon: 'assets/icons/ic_tab_attendance.svg',
      selectedIcon: 'assets/icons/ic_tab_attendance_selected.svg',
    ),
    BottomnavbarMenu(
      name: 'Pengaturan',
      icon: 'assets/icons/ic_settings.svg',
      selectedIcon: 'assets/icons/ic_settings_selected.svg',
    ),
  ];

  bool isSelected(int index) => currentIndex.value == index;

  void selectMenu(int index) {
    currentIndex.value = index;
    loadedPages.add(index);
  }
}
