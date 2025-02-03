import 'dart:async';

import 'package:get/get.dart';
import 'package:iroyal/app/modules/check_password/data/models/check_password_model.dart';
import 'package:iroyal/app/modules/check_password/domain/usecases/check_password_usecase.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';

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
        isLoading.value = false;
        checkPasswordRes.value = r;
        if (checkPasswordRes.value.data == true) {
          appDialog.showSuccessSnackBar(
            description: 'Password is correct',
          );
          Future.delayed(Duration(seconds: 1), () {
            Get.offNamed(Routes.PAYROLL);
          });
        }
      },
    );
  }

  void gotoForgotPassword() {
    appDialog.showInfoDialog(
      imagePath: 'assets/icons/ic_information.svg',
      description:
          'Please contact the IT Department\nfor further assistance.\n\nCall 0811-2465-515 or 0811-2000-5071',
      textButton: 'Continue',
    );
  }
}
