import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/data/models/attendance.dart';
import 'package:iroyal/app/modules/home/data/models/employee.dart';
import 'package:iroyal/app/modules/home/data/models/job.dart';
import 'package:iroyal/app/modules/home/domain/entities/home_slider.dart';
import 'package:iroyal/app/modules/home/domain/entities/menu.dart';
import 'package:iroyal/app/modules/home/domain/entities/user.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_user.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/home_menu.dart';
import 'package:iroyal/app/modules/notifications/domain/entities/notification_dummy.dart';
import 'package:iroyal/base/utils/app_utils.dart';

class HomeController extends GetxController {
  HomeController({required this.getUser});

  String userState = '';
  RxString id = ''.obs;

  RxBool isLoading = false.obs;
  RxBool isVisible = false.obs;

  RxInt indexSlider = 0.obs;

  RxList<HomeMenu> mainMenu = <HomeMenu>[].obs;
  RxList<NotificationsDummy> filterNewNotif = <NotificationsDummy>[].obs;

  List<Menu> getAllMenu = <Menu>[
    const Menu(
      code: 'ic_dashboard',
      name: 'Dashboard',
      isVisible: true,
    ),
    const Menu(
      code: 'ic_task',
      name: 'Tasks',
      isVisible: true,
    ),
    const Menu(
      code: 'ic_payroll',
      name: 'Payroll',
      isVisible: true,
    ),
    const Menu(
      code: 'ic_visit',
      name: 'Visit',
      isVisible: true,
    ),
    const Menu(
      code: 'ic_webtel',
      name: 'Webtel',
      isVisible: true,
    ),
    const Menu(
      code: 'ic_tracking_documents',
      name: 'Tracking Documents',
      isVisible: true,
    ),
    const Menu(
      code: 'ic_teams',
      name: 'My Teams',
      isVisible: true,
    ),
    const Menu(
      code: 'ic_others',
      name: 'Others',
      isVisible: true,
    ),
  ];

  List<HomeSlider> homeSLider = <HomeSlider>[
    const HomeSlider(
      link: '',
    ),
    const HomeSlider(
      link: '',
    ),
    const HomeSlider(
      link: '',
    ),
  ];

  List<NotificationsDummy> notifDummy = <NotificationsDummy>[
    NotificationsDummy(
      title: "You've invited to new project",
      description: "Hestia Rouge has invite you to Job Seeker Mobile App",
      date: "Jun 23, 2022 at 21:22 PM",
      isNew: true,
    ),
    NotificationsDummy(
      title: "Mention in Dashboard Responsive",
      description: "Patricia Makabe has mention you in comment",
      date: "Jun 23, 2022 at 21:22 PM",
      isNew: true,
    ),
    NotificationsDummy(
      title: "You've invited to new project",
      description: "Kevin Morgan has invite you to E-Commerce Mobile App",
      date: "Jun 23, 2022 at 21:22 PM",
      isNew: true,
    ),
    NotificationsDummy(
      title: "Request edit in Tetrisly Design System",
      description:
          "Ralph Edward wants to edit page dashboard in Tetrisly Design System",
      date: "Jun 23, 2022 at 21:22 PM",
      isNew: false,
    ),
    NotificationsDummy(
      title: "New Attachment is uploaded",
      description: "Robert Fox added file to Dark Mode",
      date: "Jun 23, 2022 at 21:22 PM",
      isNew: false,
    ),
    NotificationsDummy(
      title: "Task Assigmnment Notification",
      description:
          "Anna Polanski assigned task Improve Workflow in Flutter to Ryan F",
      date: "Jun 23, 2022 at 21:22 PM",
      isNew: false,
    ),
    NotificationsDummy(
      title: "You've invited to new project",
      description: "Hestia Rouge has invite you to Job Seeker Mobile App",
      date: "Jun 23, 2022 at 21:22 PM",
      isNew: false,
    ),
    NotificationsDummy(
      title: "Mention in Dashboard Responsive",
      description: "Patricia Makabe has mention you in comment",
      date: "Jun 23, 2022 at 21:22 PM",
      isNew: false,
    ),
    NotificationsDummy(
      title: "Request edit in Tetrisly Design System",
      description:
          "Ralph Edward wants to edit page dashboard in Tetrisly Design System",
      date: "Jun 23, 2022 at 21:22 PM",
      isNew: false,
    ),
    NotificationsDummy(
      title: "New Attachment is uploaded",
      description: "Robert Fox added file to Dark Mode",
      date: "Jun 23, 2022 at 21:22 PM",
      isNew: false,
    ),
    NotificationsDummy(
      title: "Task Assigmnment Notification",
      description:
          "Anna Polanski assigned task Improve Workflow in Flutter to Ryan F",
      date: "Jun 23, 2022 at 21:22 PM",
      isNew: false,
    ),
  ];

  Rx<User> userData = const User(
    id: 0,
    username: '',
    email: '',
    children: false,
    employee: EmployeeModel(
      id: 0,
      firstName: '',
      lastName: '',
      birthdate: '',
      gender: '',
      maritalStatus: '',
      availableLeave: 0,
    ),
    job: JobModel(
      company: '',
      department: '',
      section: '',
      position: '',
      joinDate: '',
      absenceNumber: '',
      workEmail: '',
      employeeNumber: '',
    ),
    attendance: AttendanceModel(
      todayCheckin: '',
      yesterdayCheckin: '',
      yesterdayCheckout: '',
    ),
  ).obs;

  final GetUser getUser;

  @override
  void onInit() {
    _initial();
    super.onInit();
  }

  void _initial() async {
    await _getUserData();
    _getAllMenu();
    _filterNewNotifications(notifDummy);
  }

  Future<void> _getAllMenu() async {
    // isLoading(true);
    // final cacheMenu = await getCacheMenu();
    // cacheMenu.fold(
    //   (l) => homeMenuState = 'getCacheMenuFailed',
    //   (r) {
    //     isLoading(false);
    //     homeMenuState = 'getCacheMenuSuccess';
    //     mainMenu(generateMenu(r));
    //     mainMenu.refresh();
    //   },
    // );

    // final getAllMenu = await getMenu();
    // isLoading(false);
    // getAllMenu.fold(
    //   (l) => dashboardState = 'getMenuFailed',
    //   (r) {
    //     dashboardState = 'getMenuSuccess';
    //     mainMenu(generateMenu(r));
    //     mainMenu.refresh();
    //   },
    // );
    mainMenu(generateMenu(getAllMenu));
    //     mainMenu.refresh();
  }

  List<HomeMenu> generateMenu(List<Menu> getAllMenu) {
    final homeMenu = <HomeMenu>[];

    getAllMenu.where((menu) => menu.isVisible).forEach((menu) {
      if (menu.code == 'ic_teams') {
        if (isVisible.value == true) {
          AppUtils.logApp('ISVISIBLE MENU :::::$menu');
          homeMenu.add(HomeMenu(menu: menu));
        }
      } else {
        AppUtils.logApp('ISVISIBLE MENU :::::$menu');
        homeMenu.add(HomeMenu(menu: menu));
      }
    });
    AppUtils.logApp('ISVISIBLE :::::${isVisible.value}');
    AppUtils.logApp(
        'MENU VISIBLE :::::${getAllMenu.where((menu) => menu.isVisible)}');
    return homeMenu;
  }

  Future<void> _getUserData() async {
    isLoading.value = true;
    final result = await getUser();
    result.fold(
      (l) {
        userState = 'getUserFailed';
        isLoading.value = false;
      },
      (r) {
        userState = 'getUserSuccess';
        isLoading.value = false;
        userData.value = r;
        isVisible.value = r.children;
      },
    );
  }

  void _filterNewNotifications(List<NotificationsDummy> allNotif) {
    filterNewNotif.assignAll(allNotif.where((e) => e.isNew).toList());
    filterNewNotif.refresh();
  }
}
