import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/dashboard/data/models/dashboard_data_model.dart';
import 'package:iroyal/app/modules/dashboard/data/models/dashboard_model.dart';
import 'package:iroyal/app/modules/dashboard/data/models/leave_balance_model.dart';
import 'package:iroyal/app/modules/dashboard/data/models/leave_summary_model.dart';
import 'package:iroyal/app/modules/dashboard/data/models/ptk_model.dart';
import 'package:iroyal/app/modules/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_user.dart';
import 'package:iroyal/base/utils/app_utils.dart';

class DashboardController extends GetxController {
  DashboardController({
    required this.getUser,
    required this.getDashboard,
  });
  final dataMap = <String, double>{};

  final colorList = <Color>[
    Colors.green,
    Colors.grey,
  ];

  final colorGenderList = <Color>[
    Colors.blue,
    Colors.purple,
  ];

  // final Rx<MyTeams> myTeamsData = const MyTeams(
  //   hasChildren: false,
  //   averageAge: 0.0,
  //   genderDistribution: GenderDistributionModel(male: 0.0, female: 0.0),
  //   children: [],
  // ).obs;
  final Rx<DashboardModel> dashboardData = const DashboardModel(
          code: 0,
          message: '',
          data: DashboardDataModel(
              leaveBalance: LeaveBalanceModel(0, 0),
              leaveSummary: LeaveSummaryModel(0, 0, 0),
              ptk: PtkModel(0, 0, 0)))
      .obs;

  final GetUser getUser;
  final GetDashboardUsecase getDashboard;

  RxBool isLoading = false.obs;
  RxBool hasTeams = false.obs;

  RxString id = ''.obs;
  String getIdState = '';

  RxDouble totalValueGender = 0.0.obs;
  RxInt remainingLeave = 0.obs;

  @override
  void onInit() async {
    await _getIdCacheUser();
    // hasTeams.value ? _getMyTeamsData() : null;
    _getDashboard();
    super.onInit();
  }

  Future<void> _getIdCacheUser() async {
    isLoading.value = true;
    final r = await getUser();

    r.fold(
      (l) {
        isLoading.value = false;
        getIdState = 'getIdRejected';
        AppUtils.logApp(l.toString());
      },
      (r) {
        getIdState = 'getIdSuccess';
        // id(r.employee.id.toString());
        // remainingLeave(r.employee.availableLeave);
        // hasTeams(r.children);
        AppUtils.logApp('USER ID ::::::$id');
        isLoading.value = false;
      },
    );
  }

  // Future<void> _getMyTeamsData() async {
  //   isLoading.value = true;

  //   final result = await getMyTeams(id.value);

  //   result.fold(
  //     (l) {
  //       isLoading.value = false;
  //       myTeamsState = 'getMyTeamsFailed';
  //     },
  //     (r) {
  //       myTeamsState = 'getMyTeamsSuccess';
  //       myTeamsData.value = r;
  //       totalValueGender.value = myTeamsData.value.genderDistribution.female +
  //           myTeamsData.value.genderDistribution.male;
  //       isLoading.value = false;
  //     },
  //   );
  // }

  Future<void> _getDashboard() async {
    isLoading.value = true;

    final result = await getDashboard();

    result.fold(
      (l) {
        isLoading.value = false;
      },
      (r) {
        isLoading.value = false;
        dashboardData.value = r;
        // totalValueGender.value = myTeamsData.value.genderDistribution.female +
        //     myTeamsData.value.genderDistribution.male;
      },
    );
  }

  List<PieChartSectionData> showingSectionsData() {
    final double openValue =
        dashboardData.value.data!.ptk!.open?.toDouble() ?? 1;
    final double closedValue =
        dashboardData.value.data!.ptk!.closed?.toDouble() ?? 1;

    return List.generate(2, (i) {
      const fontSize = 12.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blueAccent,
            value: openValue == 0 ? 1 : openValue,
            title: '$openValue%',
            radius: 80.r,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red,
            value: closedValue == 0 ? 1 : openValue,
            title: '$closedValue%',
            radius: 80.r,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
              shadows: shadows,
            ),
          );
        default:
          throw Exception('Invalid index for pie chart section');
      }
    });
  }
}
