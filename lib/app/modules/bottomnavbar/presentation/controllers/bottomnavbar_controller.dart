import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/attendance/widget/attendance_widget_launch_handler.dart';
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

  /// Index of the attendance tab in [bottomnavbarMenu].
  static const attendanceTab = 1;

  @override
  void onReady() {
    super.onReady();
    // Cold start from a home screen widget tap: open the attendance tab so
    // its controller is created and can run the pending action.
    if (AttendanceWidgetLaunchHandler.instance?.hasPending ?? false) {
      selectMenu(attendanceTab);
    }
  }

  bool isSelected(int index) => currentIndex.value == index;

  void selectMenu(int index) {
    currentIndex.value = index;
    loadedPages.add(index);
  }
}
