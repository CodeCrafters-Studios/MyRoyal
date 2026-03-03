import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/data/models/banner_event_model.dart';
import 'package:iroyal/app/modules/home/data/models/user_model.dart';
import 'package:iroyal/app/modules/home/data/models/user_jde_model.dart';
import 'package:iroyal/app/modules/home/data/models/user_jde_params_model.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_banner_event_usecase.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_user_jde_usecase.dart';
import 'package:iroyal/app/modules/home/data/models/user_data_model.dart';
import 'package:iroyal/app/modules/home/domain/entities/articles_entity.dart';
import 'package:iroyal/app/modules/home/domain/entities/home_slider.dart';
import 'package:iroyal/app/modules/home/domain/entities/menu.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_articles_usecase.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_user_usecase.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/home_menu.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/initialization/firebase_remote_config.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/utils/get_device_info.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeController extends GetxController {
  HomeController({
    required this.getUserUsecase,
    required this.deviceInfo,
    required this.firebaseRemoteConfig,
    required this.appDialog,
    required this.appStorage,
    required this.getArticlesUsecase,
    required this.getUserJdeUsecase,
    required this.getBannerEventUsecase,
  });

  String userState = '';
  RxString id = ''.obs;

  RxBool isLoading = false.obs;
  RxBool isVisible = false.obs;
  RxBool isImageAvailable = false.obs;

  RxInt indexSlider = 0.obs;

  RxList<HomeMenu> mainMenu = <HomeMenu>[].obs;

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
    // const Menu(
    //   code: 'ic_visit',
    //   name: 'Visit',
    // ),
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

  Rx<UserModel> userData =
      UserModel(code: 0, message: '', data: UserDataModel.empty()).obs;
  Rx<ArticlesEntites> articlesData = ArticlesEntites(data: [], total: 0).obs;
  Rx<UserJdeModel> userJdeData = UserJdeModel.empty().obs;
  Rx<BannerEventModel> bannerEventData = BannerEventModel.empty().obs;

  final GetUserUsecase getUserUsecase;
  final GetArticlesUsecase getArticlesUsecase;
  final GetUserJdeUsecase getUserJdeUsecase;
  final GetBannerEventUsecase getBannerEventUsecase;
  final DeviceInfo deviceInfo;
  final MellotippetFirebaseRemoteConfig firebaseRemoteConfig;
  final AppDialog appDialog;
  final AppStorage appStorage;
  late var newUpdate;

  @override
  void onInit() {
    super.onInit();
    _initial();
  }

  Future<void> onRefresh() async {
    checkVersion();
    await _getUserData();
    _getAllMenu();
  }

  void _initial() async {
    checkVersion();
    await _getUserData();
    _getAllMenu();

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

    // Get new update popup
    newUpdate = await appStorage.read('new-update');

    AppUtils.logApp('[INFO] NEW UPDATE :::: $newUpdate');

    final forceUpdateVersion = firebaseRemoteConfig.getForceUpdateVersion();

    // Compare the versions and display a dialog if the app version is lower than
    // the required or recommended version
    if (appVersion < requiredMinVersion) {
      _showUpdateVersionDialog(
          forceUpdateVersion, firebaseRemoteConfig.getRequiredMinimumVersion());
    } else if (appVersion < recommendedMinVersion) {
      _showUpdateVersionDialog(forceUpdateVersion,
          firebaseRemoteConfig.getRecommendedMinimumVersion());
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
        await appStorage.write('new-update', 'true');
        Get.back();
        String url = "https://play.google.com/store/apps/details?id=com.iroyal";
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        } else {
          throw 'Could not launch $url';
        }
      },
    );
  }

  void _getAllMenu() {
    mainMenu(generateHomeMenu(getAllMenu));
    mainMenu.refresh();
  }

  void _showEventDialog(String url) {
    final showEvent = firebaseRemoteConfig.showEvent();
    AppUtils.logApp('[FIREBASE] SHOW EVENT :::: $showEvent');

    (showEvent)
        ? appDialog.showEventDialog(
            isImg: true,
            imageUrl: url,
          )
        : null;
  }

  void _showWhatsNewDialog() {
    appDialog.showWhatsNewDialog(
        title: "✨ What's new? 🎉",
        description: 'MyRoyal ${deviceInfo.packageInfo.version}',
        children: [
          // Row(
          //   children: [
          //     SvgPicture.asset('assets/icons/ic_update_checklist.svg'),
          //     SizedBox(width: 10),
          //     Flexible(
          //       fit: FlexFit.loose,
          //       child: Text(
          //         'Remove event banner Independence Day of Indonesia',
          //         style: TS.bodyMedium,
          //         textAlign: TextAlign.start,
          //       ),
          //     ),
          //   ],
          // ),
          Row(
            children: [
              SvgPicture.asset('assets/icons/ic_update_fix.svg'),
              SizedBox(width: 10),
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  'Fixed several issues on download payroll',
                  style: TS.bodyMedium,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          // SizedBox(height: 8),
          // Row(
          //   children: [
          //     SvgPicture.asset('assets/icons/ic_update_improve.svg'),
          //     SizedBox(width: 10),
          //     Flexible(
          //       fit: FlexFit.loose,
          //       child: Text(
          //         'Remove border royal wiki article',
          //         style: TS.bodyMedium,
          //         textAlign: TextAlign.start,
          //       ),
          //     ),
          //   ],
          // ),
          // SizedBox(height: 8),
          // Row(
          //   children: [
          //     SvgPicture.asset('assets/icons/ic_update_improve.svg'),
          //     SizedBox(width: 10),
          //     Flexible(
          //       fit: FlexFit.loose,
          //       child: Text(
          //         'Add Banner Happy New Years & Merry Christmas',
          //         style: TS.bodyMedium,
          //         textAlign: TextAlign.start,
          //       ),
          //     ),
          //   ],
          // ),
        ],
        onPress: () async {
          await appStorage.write(
            'new-update',
            'false',
          );
          Get.back();
        });
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
    final result = await getUserUsecase();
    result.fold(
      (l) {
        userState = 'getUserFailed';
        isLoading.value = false;
      },
      (r) async {
        userState = 'getUserSuccess';
        userData.value = r;
        userData.value.data.profilePicture.isNotEmpty ||
                userData.value.data.profilePicture != ''
            ? isImageAvailable.value = true
            : isImageAvailable.value;
        _getBannerEvent();
        newUpdate == 'true' ? _showWhatsNewDialog() : null;
      },
    );
  }

  Future<void> getUserJDE(String company, String username) async {
    Get.back();
    appDialog.showLoading();

    final result = await getUserJdeUsecase.call(
      UserJdeParamsModel(
        username: username,
        company: company,
      ),
    );

    result.fold(
      (l) {
        AppDialogImpl().hideLoading();
        Get.back();
        if (l.properties.isNotEmpty && l.properties[0] is ApiException) {
          final m = l.properties[0] as ApiException;
          appDialog.showErrorDialog(
              description: m.message, textButton: 'Close');
        } else {
          appDialog.showErrorDialog(
              description: 'Unexpected error occurred', textButton: 'Close');
        }
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
          Get.toNamed(Routes.RAS_APP);
        }
      },
    );
  }

  Future<void> _getBannerEvent() async {
    isLoading.value = true;
    final result = await getBannerEventUsecase();
    result.fold(
      (l) {
        userState = 'getUserFailed';
        isLoading.value = false;
      },
      (r) async {
        bannerEventData.value = r;
        isLoading.value = false;
        await Future.delayed(Duration(milliseconds: 500));
        _showEventDialog(bannerEventData.value.data);
      },
    );
  }

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
