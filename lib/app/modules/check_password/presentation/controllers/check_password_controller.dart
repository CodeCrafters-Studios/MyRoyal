import 'dart:async';

import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/check_password/data/models/check_password_model.dart';
import 'package:MyRoyal/app/modules/check_password/domain/usecases/check_password_usecase.dart';
import 'package:MyRoyal/app/routes/app_pages.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';

class CheckPasswordController extends GetxController {
  CheckPasswordController({
    required this.checkPasswordUsecase,
    required this.appDialog,
  });

  RxString password = ''.obs;

  RxBool isValidForm = false.obs;
  RxBool isLoading = false.obs;

  Rx<CheckPasswordModel> checkPasswordRes = CheckPasswordModel(
    code: 0,
    message: '',
    data: false,
  ).obs;

  final CheckPasswordUsecase checkPasswordUsecase;
  final AppDialog appDialog;

  void validateForm() {
    isValidForm(password.isNotEmpty);
  }

  void setLoginValue(String value) {
    password(value);
    validateForm();
  }

  Future<void> checkPassword() async {
    if (!isValidForm()) {
      unawaited(AppDialogImpl()
          .showErrorSnackBar(description: 'Please input Password'));
      return;
    }

    isLoading.value = true;

    final result = await checkPasswordUsecase(
      CheckPasswordParams(
        password: password.value,
      ),
    );

    result.fold(
      (l) async {
        isLoading.value = false;
      },
      (r) {
        checkPasswordRes.value = r;
        if (checkPasswordRes.value.data == true) {
          appDialog.showSuccessSnackBar(
            description: 'Password is correct',
          );
          Future.delayed(Duration(seconds: 1), () {
            isLoading.value = false;
            Get.offNamed(Routes.PAYROLL);
          });
        }
      },
    );
  }

  void gotoForgotPassword() {
    appDialog.showForgotPasswordDialog(
      imagePath: 'assets/icons/ic_information.svg',
      description: 'Please contact the IT Department\nfor further assistance.',
      phoneNumber: '0811-2465-515',
      phoneNumber2: '0811-2000-5071',
      textButton: 'Continue',
    );
  }
}
