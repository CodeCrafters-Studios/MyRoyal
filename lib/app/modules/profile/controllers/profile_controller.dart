import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/data/models/attendance.dart';
import 'package:iroyal/app/modules/home/data/models/employee.dart';
import 'package:iroyal/app/modules/home/data/models/job.dart';
import 'package:iroyal/app/modules/home/domain/entities/user.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_user.dart';
import 'package:iroyal/app/modules/profile/domain/usecases/logout_app.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/utils/app_utils.dart';

class ProfileController extends GetxController {
  ProfileController({
    required this.logoutApp,
    required this.getUser,
  });

  final GetUser getUser;
  final LogoutApp logoutApp;

  RxBool isLoading = false.obs;
  RxBool isSwitched = false.obs;

  final iUser = const User(
    id: 0,
    username: '',
    email: '',
    employee: EmployeeModel(
      id: 0,
      firstName: '',
      lastName: '',
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
  );

  Rx<User> userData = const User(
    id: 0,
    username: '',
    email: '',
    employee: EmployeeModel(
      id: 0,
      firstName: '',
      lastName: '',
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

  @override
  void onInit() {
    iGetCacheUser();
    super.onInit();
  }

  Future<void> iGetCacheUser() async {
    isLoading.value = true;
    final data = await getUser();
    userData.value = data.getOrElse(() => iUser);
    isLoading.value = false;
    AppUtils.logApp(
        '${userData().employee.firstName} ${userData().employee.lastName}');
  }

  String getImageName() {
    final name =
        '${userData().employee.firstName} ${userData().employee.lastName}';
    if (name.isEmpty) {
      return '';
    }
    if (name.contains(' ')) {
      final ss = name.split(' ');
      return ss[0].substring(0, 1).toUpperCase() +
          ss[1].substring(0, 1).toUpperCase();
    } else {
      return name.substring(0, 1).toUpperCase();
    }
  }

  Future<void> iLogout() async {
    final result = await logoutApp();
    result.fold(
      (l) => null,
      (r) {
        if (r) {
          Get.offAllNamed(Routes.LOGIN);
        }
      },
    );
  }
}
