import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/home/domain/usecases/get_cache_user_usecase.dart';
import 'package:MyRoyal/app/modules/my_teams/data/models/child_model.dart';
import 'package:MyRoyal/app/modules/my_teams/data/models/gender_distribution_model.dart';
import 'package:MyRoyal/app/modules/my_teams/domain/entities/my_teams.dart';
import 'package:MyRoyal/app/modules/my_teams/domain/usecases/get_my_teams.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';

class MyTeamsController extends GetxController {
  MyTeamsController({
    required this.getMyTeams,
    required this.getCacheUser,
    required this.appDialog,
  });

  final TextEditingController searchE = TextEditingController();
  final GetMyTeams getMyTeams;
  final GetCacheUserUsecase getCacheUser;
  final AppDialog appDialog;

  final RxBool isLoading = false.obs;

  RxString id = ''.obs;

  String getIdState = '';

  final Rx<MyTeams> myTeamsData = const MyTeams(
    hasChildren: false,
    averageAge: 0.0,
    genderDistribution: GenderDistributionModel(male: 0.0, female: 0.0),
    children: [],
  ).obs;
  final RxList<ChildModel> filteredList = <ChildModel>[].obs;

  String myTeamsState = '';

  @override
  void onInit() async {
    await _getIdCacheUser();
    await _getMyTeamsData();
    super.onInit();
  }

  Future<void> _getIdCacheUser() async {
    isLoading.value = true;
    final r = await getCacheUser();

    r.fold(
      (l) {
        isLoading.value = false;
        getIdState = 'getIdRejected';
      },
      (r) {
        getIdState = 'getIdSuccess';
        // id(r.employee.id.toString());
        AppUtils.logApp('USER ID ::::::$id');
        isLoading.value = false;
      },
    );
  }

  Future<void> _getMyTeamsData() async {
    isLoading.value = true;

    final result = await getMyTeams(id.value);

    result.fold(
      (l) {
        isLoading.value = false;
        myTeamsState = 'getMyTeamsFailed';
      },
      (r) {
        myTeamsState = 'getMyTeamsSuccess';
        myTeamsData.value = r;
        filteredList.value = r.children;
        isLoading.value = false;
      },
    );
  }

  String getImageName() {
    final List<String> initials = myTeamsData.value.children
        .map((child) => child.fullName.split(' ').map((part) => part[0]).join())
        .toList();
    return initials.join().toUpperCase();
  }

  void onChanged(String value) {
    AppUtils.logApp(value);
    if (value.isEmpty) {
      filteredList.value = myTeamsData().children;
    } else {
      filteredList.value = myTeamsData()
          .children
          .where((e) => e.fullName.toLowerCase().contains(value.toLowerCase()))
          .toList();
      filteredList.value = myTeamsData.value.children
          .where((e) => e.children.any(
              (f) => f.fullName.toLowerCase().contains(value.toLowerCase())))
          .toList();
      AppUtils.logApp('${filteredList.length}');
    }
  }
}
