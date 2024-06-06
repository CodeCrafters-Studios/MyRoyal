import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_user.dart';
import 'package:iroyal/app/modules/my_teams/data/models/gender_distribution_model.dart';
import 'package:iroyal/app/modules/my_teams/domain/entities/my_teams.dart';
import 'package:iroyal/app/modules/my_teams/domain/usecases/get_my_teams.dart';
import 'package:iroyal/base/utils/app_utils.dart';

class DashboardController extends GetxController {
  DashboardController({
    required this.getMyTeams,
    required this.getUser,
  });
  final dataMap = <String, double>{
    "Balance": 2,
    "Used": 8,
  };

  final colorList = <Color>[
    Colors.green,
    Colors.grey,
  ];

  final colorGenderList = <Color>[
    Colors.blue,
    Colors.purple,
  ];

  final Rx<MyTeams> myTeamsData = const MyTeams(
    hasChildren: false,
    averageAge: 0.0,
    genderDistribution: GenderDistributionModel(male: 0.0, female: 0.0),
    children: [],
  ).obs;
  final GetMyTeams getMyTeams;
  final GetUser getUser;

  RxBool isLoading = false.obs;

  RxString id = ''.obs;
  String getIdState = '';
  String myTeamsState = '';

  RxDouble totalValueGender = 0.0.obs;

  @override
  void onInit() async {
    await _getIdCacheUser();
    await _getMyTeamsData();
    super.onInit();
  }

  Future<void> _getIdCacheUser() async {
    isLoading.value = true;
    final r = await getUser();

    r.fold(
      (l) {
        isLoading.value = false;
        getIdState = 'getIdRejected';
      },
      (r) {
        getIdState = 'getIdSuccess';
        id(r.employee.id.toString());
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
        totalValueGender.value = myTeamsData.value.genderDistribution.female +
            myTeamsData.value.genderDistribution.male;
        isLoading.value = false;
      },
    );
  }

  Map<String, double> getGenderDistributionMap() {
    return myTeamsData.value.genderDistribution.toMap();
  }
}
