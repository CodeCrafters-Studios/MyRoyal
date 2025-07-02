import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/data/models/user_jde_model.dart';
import 'package:iroyal/app/modules/home/data/models/user_jde_params_model.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_user_jde_usecase.dart';
import 'package:iroyal/app/modules/home/data/models/user_data.dart';
import 'package:iroyal/app/modules/home/domain/entities/articles_entites.dart';
import 'package:iroyal/app/modules/home/domain/entities/home_slider.dart';
import 'package:iroyal/app/modules/home/domain/entities/menu.dart';
import 'package:iroyal/app/modules/home/domain/entities/user.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_articles_usecase.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_user.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/home_menu.dart';
import 'package:iroyal/app/modules/notifications/data/models/notification_data_list_model.dart';
import 'package:iroyal/app/modules/notifications/data/models/notification_data_model.dart';
import 'package:iroyal/app/modules/notifications/domain/entities/notification_entities.dart';
import 'package:iroyal/app/modules/notifications/domain/usecases/get_notifications.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/initialization/firebase_remote_config.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/utils/get_device_info.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';
import 'package:iroyal/base/widgets/others/coming_soon.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  HomeController({
    required this.getUser,
    required this.getNotifications,
    required this.deviceInfo,
    required this.firebaseRemoteConfig,
    required this.appDialog,
    required this.appStorage,
    required this.getArticles,
    required this.getUserJde,
  });

  String userState = '';
  RxString id = ''.obs;

  RxBool isLoading = false.obs;
  RxBool isVisible = false.obs;
  RxBool isImageAvailable = false.obs;

  RxInt indexSlider = 0.obs;

  RxList<HomeMenu> mainMenu = <HomeMenu>[].obs;
  RxList<NotificationDataListModel> filterNewNotif =
      <NotificationDataListModel>[].obs;

  List<Menu> getAllMenu = <Menu>[
    const Menu(
      code: 'ic_dashboard',
      name: 'Dashboard',
    ),
    const Menu(
      code: 'ic_leaves',
      name: 'Leaves',
    ),
    const Menu(
      code: 'ic_payroll',
      name: 'Payroll',
    ),
    const Menu(
      code: 'ic_visit',
      name: 'Visit',
    ),
    const Menu(
      code: 'ic_webtel',
      name: 'Webtel',
    ),
    const Menu(
      code: 'ic_tracking_documents',
      name: 'Tracking Documents',
    ),

    const Menu(
      code: 'ic_online_app',
      name: 'Online App',
    ),
    const Menu(
      code: 'ic_approval',
      name: 'Approval',
    ),
    // const Menu(
    //   code: 'ic_task',
    //   name: 'Tasks',
    // ),
    // const Menu(
    //   code: 'ic_teams',
    //   name: 'My Teams',
    //   isVisible: true,
    // ),
    // const Menu(
    //   code: 'ic_others',
    //   name: 'Others',
    //   isVisible: true,
    // ),
  ];

  List<HomeSlider> homeSlider = <HomeSlider>[
    const HomeSlider(
      id: '8',
      title: 'IT Governance (Tata Kelola Teknologi Informasi)',
      subtitle:
          "IT Governance (Tata Kelola Teknologi Informasi) adalah proses yang mengatur penggunaan teknologi informasi (TI) di dalam suatu organisasi atau perusahaan. IT Governance bertujuan untuk memastikan bahwa TI digunakan secara efektif, efisien, dan aman, serta sesuai dengan tujuan bisnis perusahaan.",
      imgUrl:
          'https://wiki.royalcorp.co.id/uploads/images/cover_bookshelf/2024-12/thumbs-440-250/qXKdfeGxJx1mCo4J-image-2024-12-11-211422472.png',
      url:
          'https://wiki.royalcorp.co.id/shelves/it-governance-tata-kelola-teknologi-informasi',
    ),
    const HomeSlider(
      id: '7',
      title: 'HRMS',
      subtitle:
          "a comprehensive guide for hrms project writen by HRMS Member and Developer",
      imgUrl:
          'https://wiki.royalcorp.co.id/uploads/images/cover_bookshelf/2024-12/thumbs-440-250/pNVIzyfjBXOStUgw-ras-logo.png',
      url: 'https://wiki.royalcorp.co.id/shelves/hrms',
    ),
    const HomeSlider(
      id: '2',
      title: 'IT Infrastructure & Support',
      subtitle:
          "Comprehensive knowledge sharing on IT Infrastructure & Support.",
      imgUrl:
          'https://wiki.royalcorp.co.id/uploads/images/cover_bookshelf/2024-12/thumbs-440-250/6nnfCLWOnOSFNETe-infra-support.jpeg',
      url: 'https://wiki.royalcorp.co.id/shelves/it-infrastructure-support',
    ),
  ];

  Rx<User> userData =
      User(code: 0, message: '', data: UserDataModel.empty()).obs;
  Rx<NotificationEntities> notificationsData = const NotificationEntities(
          code: 0,
          message: '',
          data: NotificationDataModel(currentPage: 0, data: [], totalPage: 0))
      .obs;
  Rx<ArticlesEntites> articlesData = ArticlesEntites(data: [], total: 0).obs;
  Rx<UserJdeModel> userJdeData = UserJdeModel.empty().obs;

  final GetUser getUser;
  final GetNotifications getNotifications;
  final GetArticlesUsecase getArticles;
  final GetUserJdeUsecase getUserJde;
  final DeviceInfo deviceInfo;
  final MellotippetFirebaseRemoteConfig firebaseRemoteConfig;
  final AppDialog appDialog;
  final AppStorage appStorage;

  @override
  void onInit() {
    _initial();
    super.onInit();
  }

  Future<void> onRefresh() async {
    await _getUserData();
    _getAllMenu();
    await _getNotifications();
    _filterNewNotifications(notificationsData().data.data);
    checkVersion();
  }

  void _initial() async {
    await _getUserData();
    _getAllMenu();
    await _getNotifications();
    _filterNewNotifications(notificationsData().data.data);
    checkVersion();
    // _showEventDialog();
    // _getArticles();
  }

  void checkVersion() async {
    // Get the current app version
    final appVersion =
        _getExtendedVersionNumber(deviceInfo.packageInfo.version);

    // Get the required min version from Firebase Remote Config
    final requiredMinVersion = _getExtendedVersionNumber(
        firebaseRemoteConfig.getRequiredMinimumVersion());

    // Get the recommended min version from Firebase Remote Config
    final recommendedMinVersion = _getExtendedVersionNumber(
        firebaseRemoteConfig.getRecommendedMinimumVersion());

    final forceUpdateVersion = firebaseRemoteConfig.getForceUpdateVersion();

    AppUtils.logApp('APP VERSION :::: $appVersion');
    AppUtils.logApp('APP VERSION REQUIRED :::: $requiredMinVersion');
    AppUtils.logApp('APP VERSION RECOMMENDED :::: $recommendedMinVersion');
    AppUtils.logApp('APP VERSION FORCE UPDATE :::: $forceUpdateVersion');
    // Compare the versions and display a dialog if the app version is lower than
    // the required or recommended version
    if (appVersion < requiredMinVersion) {
      _showUpdateVersionDialog(
          forceUpdateVersion, firebaseRemoteConfig.getRequiredMinimumVersion());
    } else if (appVersion < recommendedMinVersion) {
      _showUpdateVersionDialog(forceUpdateVersion,
          firebaseRemoteConfig.getRecommendedMinimumVersion());
    } else {
      emptyBox;
    }
  }

  // Helper method to compare two semver versions.
  int _getExtendedVersionNumber(String version) {
    List<String> versionCells = version.split('.');
    List<int> versionNumbers = versionCells.map((i) => int.parse(i)).toList();

    return versionNumbers[0] * 100000 +
        versionNumbers[1] * 1000 +
        versionNumbers[2];
  }

  void _showUpdateVersionDialog(
      bool isForceUpdateVersion, String recommendedMinVersion) {
    appDialog.showAppVersionInfoDialog(
        isForceUpdateVersion: isForceUpdateVersion,
        title: 'New version available',
        description:
            'There is a new version $recommendedMinVersion available in the Google Play Store. Would you like to update?',
        onPressLater: Get.back,
        onPressUpdate: () async {
          Get.back();
          String url =
              "https://play.google.com/store/apps/details?id=com.iroyal";
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url),
                mode: LaunchMode.externalApplication);
          } else {
            throw 'Could not launch $url';
          }
        });
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
    mainMenu(generateHomeMenu(getAllMenu));
    //     mainMenu.refresh();
  }

  List<HomeMenu> generateHomeMenu(List<Menu> getAllMenu) {
    final homeMenu = <HomeMenu>[];

    final mappedMenus = getAllMenu.map((menu) {
      return HomeMenu(menu: menu, appStorage: appStorage);
    }).toList();

    if (userData().data.position == 'Staff') {
      homeMenu.addAll(mappedMenus);
      homeMenu.removeWhere((x) => x.menu.name == 'Approval');
    } else {
      homeMenu.addAll(mappedMenus);
    }

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
        userData.value.data.profilePicture.isNotEmpty ||
                userData.value.data.profilePicture != ''
            ? isImageAvailable.value = true
            : isImageAvailable.value;
      },
    );
  }

  Future<void> getUserJDE(String company, String username) async {
    appDialog.showLoading();

    final result = await getUserJde.call(
      UserJdeParamsModel(
        username: username,
        company: company,
      ),
    );
    // userData.value.data.username

    result.fold(
      (l) {
        AppDialogImpl().hideLoading();
        Get.back();
        AppUtils.logApp('ERROR R ${l.properties}');
        final m = l.properties[0] as ApiException;
        appDialog.showErrorDialog(description: m.message);
      },
      (r) async {
        AppDialogImpl().hideLoading();
        Get.back();
        userJdeData.value = r;
        await appStorage.write(
            USER_ID_JDE, userJdeData.value.data.data.first.userid);
        if (company == 'CAM') {
          Get.toNamed(Routes.CAM_APP);
        } else {
          Get.to(ComingSoonScreen());
        }
      },
    );
  }

  Future<void> _getNotifications() async {
    isLoading.value = true;

    final result = await getNotifications(1);

    result.fold(
      (l) {
        isLoading.value = false;
      },
      (r) {
        isLoading.value = false;
        notificationsData.value = r;
      },
    );
  }

  List<NotificationDataListModel> _filterNewNotifications(
      List<NotificationDataListModel> getNewNotifications) {
    filterNewNotif.clear();
    filterNewNotif.addAll(
        getNewNotifications.where((notif) => notif.isRead == false).toList());

    return filterNewNotif;
  }

  // void _showEventDialog() {
  //   appDialog.showEventDialog(
  //     isImg: true,
  //     imagePath: 'assets/images/img_idul_adha.gif',
  //   );
  // }

  // Future<void> _getArticles() async {
  //   isLoading.value = true;
  //   final result = await getArticles();
  //   result.fold(
  //     (l) {
  //       isLoading.value = false;
  //     },
  //     (r) {
  //       isLoading.value = false;
  //       articlesData.value = r;
  //     },
  //   );
  // }
}
