import 'package:get/get.dart';
import 'package:iroyal/base/utils/app_utils.dart';

class ChangePasswordController extends GetxController {
  RxString newPassword = ''.obs;
  RxString confirmPassword = ''.obs;

  RxBool passwordValidation = false.obs;
  RxBool containsNumber = false.obs;

  void setNewPassword(String value) {
    newPassword.value = value;

    final alphanumeric = RegExp(r'^[A-Za-z0-9_.]+$');
    final hasNumber = RegExp(r'[0-9]');

    containsNumber.value = hasNumber.hasMatch(newPassword.value);
    // if (alphanumeric.hasMatch(newPassword.value)) {
    //   AppUtils.logApp(newPassword.value);
    //   passwordValidation.value = true;
    //   AppUtils.logApp('${passwordValidation.value}');
    // } else {
    //   passwordValidation.value = false;
    // }
  }

  void setConfirmPassword(String value) {
    confirmPassword.value = value;
  }
}
