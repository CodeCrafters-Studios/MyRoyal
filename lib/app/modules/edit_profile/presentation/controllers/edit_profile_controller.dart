import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/edit_profile/domain/entities/employee_params.dart';
import 'package:iroyal/app/modules/edit_profile/domain/usecases/patch_edit_profile.dart';
import 'package:iroyal/app/modules/profile/domain/entities/profile.dart';
import 'package:iroyal/base/utils/app_utils.dart';

enum FormLoginValue { email, npwp }

class EditProfileController extends GetxController {
  EditProfileController({required this.patchEditProfileUseCase});

  TextEditingController emailController = TextEditingController();

  RxBool isLoading = false.obs;

  RxString personalEmail = ''.obs;
  RxString npwp = ''.obs;

  final PatchEditProfile patchEditProfileUseCase;

  Profile argumentData = Get.arguments;

  @override
  void onInit() {
    print(argumentData.personal.npwp);
    super.onInit();
  }

  void setEditProfileValue(FormLoginValue key, String value) {
    switch (key) {
      case FormLoginValue.email:
        personalEmail(value);
        AppUtils.logApp(personalEmail.value);
        break;
      case FormLoginValue.npwp:
        npwp(value);
        AppUtils.logApp(npwp.value);
        break;
    }
  }

  Future<void> patchEditProfile() async {
    AppUtils.logApp(personalEmail());
    AppUtils.logApp(npwp());

    isLoading(true);
    final r = await patchEditProfileUseCase(ParamsEditProfile(
      employeeParams: EmployeeParams(
        lastName: personalEmail.value.isEmpty
            ? argumentData.personal.lastName
            : personalEmail.value,
        npwp: npwp.value,
      ),
      id: '22',
    ));
    r.fold((l) {
      isLoading(false);
      AppUtils.logApp('Failure');
    }, (r) {
      AppUtils.logApp('Success');
    });
  }
}
