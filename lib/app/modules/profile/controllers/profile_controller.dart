import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/data/models/attendance.dart';
import 'package:iroyal/app/modules/home/data/models/employee.dart';
import 'package:iroyal/app/modules/home/data/models/job.dart';
import 'package:iroyal/app/modules/home/domain/entities/user.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_user.dart';
import 'package:iroyal/app/modules/profile/domain/usecases/biometrics_app.dart';
import 'package:iroyal/app/modules/profile/domain/usecases/logout_app.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';

class ProfileController extends GetxController {
  ProfileController({
    required this.logoutApp,
    required this.biometricsApp,
    required this.getUser,
    required this.appStorage,
  });

  final GetUser getUser;
  final LogoutApp logoutApp;
  final BiometricsApp biometricsApp;
  final AppStorage appStorage;

  RxBool isLoading = false.obs;
  RxBool isSwitched = false.obs;
  RxBool bioValue = false.obs;

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
    setValue();
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

  Future<void> iBiometrics(bool value) async {
    final result = await biometricsApp(); // Call the biometricsApp use case
    result.fold(
      (l) => null,
      (r) {
        if (r) {
          isSwitched.value = value;
          bioValue.value = value;
          appStorage.write('fingerprint-login', value.toString());
          AppUtils.logApp('FINGERPRINT VALUE iBiometrics:::::: $value');
        }
      },
    );
  }

  void setValue() async {
    final fingerprintLogin = await appStorage.read('fingerprint-login');
    if (fingerprintLogin == 'true') {
      bioValue.value = true;
      AppUtils.logApp('BIO VALUE :::::::::: ${bioValue.value}');
    } else if (fingerprintLogin == null || fingerprintLogin == '') {
      bioValue.value = false;
    } else {
      bioValue.value = false;
    }
  }
}
