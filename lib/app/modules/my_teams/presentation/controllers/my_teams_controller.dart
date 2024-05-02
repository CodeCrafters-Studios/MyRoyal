import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_user.dart';
import 'package:iroyal/app/modules/my_teams/data/models/child_model.dart';
import 'package:iroyal/app/modules/my_teams/data/models/gender_distribution_model.dart';
import 'package:iroyal/app/modules/my_teams/domain/entities/my_teams.dart';
import 'package:iroyal/app/modules/my_teams/domain/usecases/get_my_teams.dart';
import 'package:iroyal/base/utils/app_utils.dart';

class MyTeamsController extends GetxController {
  MyTeamsController({
    required this.getMyTeams,
    required this.getUser,
  });

  final TextEditingController searchE = TextEditingController();
  final GetMyTeams getMyTeams;
  final GetUser getUser;

  final RxBool isLoading = false.obs;
  final RxBool isExpand = false.obs;

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

  get appStorage => null;

  @override
  void onInit() async {
    await _getIdCacheUser();
    await _getMyTeamsData();
    super.onInit();
  }

  Future<void> _getIdCacheUser() async {
    final r = await getUser();
    r.fold(
      (l) => getIdState = 'getIdRejected',
      (r) {
        getIdState = 'getIdSuccess';
        id(r.employee.id.toString());
        AppUtils.logApp('USER ID ::::::$id');
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
        isLoading.value = false;
        myTeamsState = 'getMyTeamsSuccess';
        myTeamsData.value = r;
        filteredList.value = r.children;
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
      isExpand.value = false;
    } else {
      filteredList.value = myTeamsData()
          .children
          .where((e) => e.fullName.toLowerCase().contains(value.toLowerCase()))
          .toList();
      filteredList.value = myTeamsData.value.children
          .where((e) => e.children.any(
              (f) => f.fullName.toLowerCase().contains(value.toLowerCase())))
          .toList();
      isExpand.value = true;
      AppUtils.logApp('${filteredList.length}');
    }
  }
}
