import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_user.dart';
import 'package:iroyal/app/modules/profile/domain/entities/profile.dart';
import 'package:iroyal/app/modules/profile/domain/usecases/get_profile.dart';
import 'package:iroyal/base/utils/app_utils.dart';

class ProfileController extends GetxController {
  ProfileController({
    required this.getProfile,
    required this.getUser,
  });

  final GetProfile getProfile;
  final GetUser getUser;

  final RxBool isLoading = false.obs;

  RxString id = ''.obs;

  String getIdState = '';
  String profileState = '';

  final Rx<Profile> profileData = Profile(
    fullName: '',
    company: '',
    department: '',
    position: '',
    reportTo: '',
    remainingLeave: 0,
    birthdate: DateTime(0),
    email: '',
    gender: '',
    instagram: '',
    linkedin: '',
  ).obs;

  @override
  void onInit() async {
    AppUtils.logApp('INIT PROFILE');
    await _getIdCacheUser();
    await _getProfileData();
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

  Future<void> _getProfileData() async {
    isLoading.value = true;

    final result = await getProfile(id.value);

    result.fold(
      (l) {
        isLoading.value = false;
        profileState = 'getProfileFailed';
      },
      (r) {
        isLoading.value = false;
        profileState = 'getProfileSuccess';
        profileData.value = r;
      },
    );
  }
}
