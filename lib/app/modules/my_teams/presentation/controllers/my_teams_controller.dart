import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/my_teams/data/models/child_model.dart';
import 'package:iroyal/app/modules/my_teams/data/models/gender_distribution_model.dart';
import 'package:iroyal/app/modules/my_teams/domain/entities/my_teams.dart';
import 'package:iroyal/app/modules/my_teams/domain/usecases/get_my_teams.dart';

class MyTeamsController extends GetxController {
  MyTeamsController({required this.getMyTeams});

  final TextEditingController searchE = TextEditingController();
  final GetMyTeams getMyTeams;

  final RxBool isLoading = false.obs;
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
    await getMyTeamsData();
    super.onInit();
  }

  Future<void> getMyTeamsData() async {
    isLoading.value = true;
    final result = await getMyTeams();
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
    if (value.isEmpty) {
      filteredList.value = myTeamsData().children;
    } else {
      filteredList.value = myTeamsData()
          .children
          .where((e) => e.fullName.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
  }
}
