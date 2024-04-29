import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/my_teams/data/models/child_model.dart';
import 'package:iroyal/app/modules/my_teams/data/models/gender_distribution_model.dart';
import 'package:iroyal/app/modules/my_teams/domain/entities/my_teams.dart';
import 'package:iroyal/app/modules/my_teams/domain/usecases/get_my_teams.dart';

class MyTeamsController extends GetxController {
  MyTeamsController({required this.getMyTeams});
  TextEditingController searchE = TextEditingController();

  String myTeamsState = '';
  RxBool isLoading = false.obs;

  final GetMyTeams getMyTeams;
  RxList<ChildModel> filteredList = <ChildModel>[].obs;

  Rx<MyTeams> myTeamsData = const MyTeams(
    hasChildren: false,
    averageAge: 0.0,
    genderDistribution: GenderDistributionModel(male: 0.0, female: 0.0),
    children: [],
  ).obs;

  @override
  void onInit() async {
    await getMyTeamsData();
    filteredList.value = myTeamsData().children;
    super.onInit();
  }

  Future<void> getMyTeamsData() async {
    isLoading.value = true;
    final result = await getMyTeams();
    result.fold(
      (l) {
        myTeamsState = 'getMyTeamsFailed';
        isLoading.value = false;
      },
      (r) {
        myTeamsState = 'getMyTeamsSuccess';
        isLoading.value = false;
        myTeamsData.value = r;
      },
    );
  }

  String getImageName() {
    final children = myTeamsData.value.children;
    if (children.isEmpty) {
      return '';
    }

    // List to store initials
    final initials = <String>[];

    // Loop through all children
    for (final child in children) {
      final fullName = child.fullName;

      if (fullName.isNotEmpty) {
        // Splitting the full name by space and taking the first character of each part
        final initial = fullName.split(' ').map((part) => part[0]).join();
        initials.add(initial);
      }
    }

    // Joining the initials and converting them to uppercase
    return initials.join().toUpperCase();
  }

  void onChanged(String value) {
    List<ChildModel> result = <ChildModel>[];
    if (value.isEmpty) {
      result = myTeamsData().children;
    } else {
      result = myTeamsData()
          .children
          .where((e) => e.fullName.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    filteredList.value = result;
  }
}
