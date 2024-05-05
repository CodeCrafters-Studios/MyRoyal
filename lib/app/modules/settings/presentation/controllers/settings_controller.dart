import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/data/models/attendance.dart';
import 'package:iroyal/app/modules/home/data/models/employee.dart';
import 'package:iroyal/app/modules/home/data/models/job.dart';
import 'package:iroyal/app/modules/home/domain/entities/user.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_user.dart';
import 'package:iroyal/app/modules/settings/domain/usecases/biometrics_app.dart';
import 'package:iroyal/app/modules/settings/domain/usecases/logout_app.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';

class SettingsController extends GetxController {
  SettingsController({
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
  RxBool biometricsValue = false.obs;

  final iUser = const User(
    id: 0,
    username: '',
    email: '',
    children: false,
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
    children: false,
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
    _initial();
    super.onInit();
  }

  void _initial() {
    setBiometricsValue();
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
          biometricsValue.value = value;
          appStorage.write('fingerprint-login', value.toString());
          AppUtils.logApp('FINGERPRINT VALUE iBiometrics:::::: $value');
        }
      },
    );
  }

  void setBiometricsValue() async {
    final fingerprintLogin = await appStorage.read('fingerprint-login');
    if (fingerprintLogin == 'true') {
      biometricsValue.value = true;
      AppUtils.logApp('BIO VALUE :::::::::: ${biometricsValue.value}');
    } else {
      biometricsValue.value = false;
      AppUtils.logApp('BIO VALUE :::::::::: ${biometricsValue.value}');
    }
  }
}
