import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/data/models/attendance.dart';
import 'package:iroyal/app/modules/home/data/models/employee.dart';
import 'package:iroyal/app/modules/home/data/models/job.dart';
import 'package:iroyal/app/modules/home/domain/entities/user.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_user.dart';

class HomeController extends GetxController {
  HomeController({required this.getUser});

  String userState = '';
  RxBool isLoading = false.obs;

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

  final GetUser getUser;

  @override
  void onInit() {
    getUserData();
    super.onInit();
  }

  Future<void> getUserData() async {
    isLoading.value = true;
    final result = await getUser();
    result.fold(
      (l) {
        userState = 'getUserFailed';
        isLoading.value = false;
      },
      (r) {
        userState = 'getUserSuccess';
        isLoading.value = false;
        userData.value = r;
      },
    );
  }
}
