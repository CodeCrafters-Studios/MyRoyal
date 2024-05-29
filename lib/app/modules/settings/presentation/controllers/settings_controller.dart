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
import 'package:iroyal/base/utils/biometrics.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';

class SettingsController extends GetxController {
  SettingsController({
    required this.logoutApp,
    required this.biometricsApp,
    required this.getUser,
    required this.appStorage,
    required this.authBiometrics,
  });

  final GetUser getUser;
  final LogoutApp logoutApp;
  final BiometricsApp biometricsApp;
  final AppStorage appStorage;
  final AuthBiometrics authBiometrics;

  RxBool isLoading = false.obs;
  RxBool switchbiometricsValue = false.obs;
  RxBool getAvailableBiometrics = false.obs;

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
    _setSwitchBiometricsValue();
    _getAvailableBiometrics();
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
    final result = await biometricsApp();
    result.fold(
      (l) => null,
      (r) {
        if (r) {
          switchbiometricsValue.value = value;
          // Save switch biometrics value enable / disable

          appStorage.write('switch-biometrics-value', value.toString());
          AppUtils.logApp('FINGERPRINT VALUE iBiometrics:::::: $value');
        }
      },
    );
  }

  void _setSwitchBiometricsValue() async {
    final checkSwitchBiometricsValue =
        await appStorage.read('switch-biometrics-value');

    if (checkSwitchBiometricsValue == 'true') {
      // Value switch button enable / turn on

      switchbiometricsValue.value = true;
      AppUtils.logApp('BIO VALUE :::::::::: ${switchbiometricsValue.value}');
    } else {
      // Value switch button disable / turn off

      switchbiometricsValue.value = false;
      AppUtils.logApp('BIO VALUE :::::::::: ${switchbiometricsValue.value}');
    }
  }

  void _getAvailableBiometrics() async {
    await authBiometrics.isSupported();

    final getAvailableBiometricsStorage =
        await appStorage.read('get-available-biometrics');

    if (getAvailableBiometricsStorage == 'true') {
      // Show switch button biometrics
      getAvailableBiometrics.value = true;
    } else {
      // Hide switch button biometrics
      appStorage.write('switch-biometrics-value', 'false');
      getAvailableBiometrics.value = false;
    }
  }
}
