import 'package:MyRoyal/app/shared/services/in_app_review_service.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/home/data/models/banner_event_model.dart';
import 'package:MyRoyal/app/modules/home/data/models/user_model.dart';
import 'package:MyRoyal/app/modules/home/data/models/user_jde_model.dart';
import 'package:MyRoyal/app/modules/home/data/models/user_jde_params_model.dart';
import 'package:MyRoyal/app/modules/home/domain/usecases/get_banner_event_usecase.dart';
import 'package:MyRoyal/app/modules/home/domain/usecases/get_user_jde_usecase.dart';
import 'package:MyRoyal/app/modules/home/data/models/user_data_model.dart';
import 'package:MyRoyal/app/modules/home/domain/entities/articles_entity.dart';
import 'package:MyRoyal/app/modules/home/domain/entities/menu.dart';
import 'package:MyRoyal/app/modules/home/domain/usecases/get_articles_usecase.dart';
import 'package:MyRoyal/app/modules/home/domain/usecases/get_user_usecase.dart';
import 'package:MyRoyal/app/modules/home/presentation/views/components/home_menu.dart';
import 'package:MyRoyal/app/routes/app_pages.dart';
import 'package:MyRoyal/base/config/app_constants.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/initialization/firebase_remote_config.dart';
import 'package:MyRoyal/base/services/http_service.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';
import 'package:MyRoyal/base/utils/get_device_info.dart';
import 'package:MyRoyal/base/utils/storage/app_storage.dart';

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
  bool _isInitialized = false;

  RxInt indexSlider = 0.obs;

  RxList<HomeMenu> mainMenu = <HomeMenu>[].obs;
  RxList<BannerEventModel> homeSlider = <BannerEventModel>[].obs;

  List<Menu> getAllMenu = <Menu>[
    const Menu(
      id: 1,
      code: 'ic_dashboard',
      name: 'Dasbor',
    ),
    const Menu(
      id: 2,
      code: 'ic_leaves',
      name: 'Izin/Cuti',
    ),
    const Menu(
      id: 3,
      code: 'ic_payroll',
      name: 'Slip Gaji',
    ),
    // const Menu(
    //   code: 'ic_visit',
    //   name: 'Visit',
    // ),
    const Menu(
      id: 4,
      code: 'ic_webtel',
      name: 'Webtel',
    ),
    const Menu(
      id: 5,
      code: 'ic_tracking_documents',
      name: 'Lacak Dokumen',
    ),

    const Menu(
      id: 6,
      code: 'ic_online_app',
      name: 'Aplikasi Online',
    ),
    const Menu(
      id: 7,
      code: 'ic_approval',
      name: 'Persetujuan',
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

  Rx<UserModel> userData =
      UserModel(code: 0, message: '', data: UserDataModel.empty()).obs;
  Rx<ArticlesEntites> articlesData = ArticlesEntites(data: [], total: 0).obs;
  Rx<UserJdeModel> userJdeData = UserJdeModel.empty().obs;

  final GetUserUsecase getUserUsecase;
  final GetArticlesUsecase getArticlesUsecase;
  final GetUserJdeUsecase getUserJdeUsecase;
  final GetBannerEventUsecase getBannerEventUsecase;
  final DeviceInfo deviceInfo;
  final MellotippetFirebaseRemoteConfig firebaseRemoteConfig;
  final AppDialog appDialog;
  final AppStorage appStorage;
  final inAppReviewService = InAppReviewService();
  late var newUpdate;

  @override
  void onInit() {
    super.onInit();

    _getAllMenu();

    final httpService = Get.find<HttpService>();

    ever(httpService.connectionStatus, (String status) {
      if (status == "No connection") {
        isLoading.value = true;
      } else {
        _runInitialOnce();
      }
    });

    _runInitialOnce();
  }

  void _runInitialOnce() {
    if (_isInitialized) return;

    final httpService = Get.find<HttpService>();

    if (httpService.connectionStatus.value == "No connection") return;

    _isInitialized = true;
    _initial();
  }

  Future<void> onRefresh() async {
    await _getUserData();
  }

  void _initial() async {
    await _getUserData();

    // Check and trigger custom in-app review dialog on launch count threshold
    inAppReviewService.checkAndTriggerUsageReview(appStorage,
        minAppUsageCount: 5);

    // _getArticles();
  }

  void _getAllMenu() {
    mainMenu(generateHomeMenu(getAllMenu));
    mainMenu.refresh();
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
        homeSlider.value = <BannerEventModel>[];
        isLoading.value = false;
      },
      (r) async {
        homeSlider.value = r;
        isLoading.value = false;
      },
    );
  }
}
