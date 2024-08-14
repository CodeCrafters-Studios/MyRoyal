import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/edit_profile/data/model/employee_params_model.dart';
import 'package:iroyal/app/modules/edit_profile/domain/usecases/patch_edit_profile.dart';
import 'package:iroyal/app/modules/profile/domain/entities/profile.dart';
import 'package:iroyal/app/modules/profile/presentation/controllers/profile_controller.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';

enum FormLoginValue {
  firstName,
  lastName,
  nickname,
  npwp,
  npwpStatus,
  email,
  instagram,
  linkedin,
  maritalStatus,
}

class EditProfileController extends GetxController {
  EditProfileController({
    required this.patchEditProfileUseCase,
    required this.appDialog,
  });

  final PatchEditProfile patchEditProfileUseCase;
  final AppDialog appDialog;
  Profile argumentData = Get.arguments[0];
  final String id = Get.arguments[1];

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController npwpController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool enableButton = false.obs;

  RxString fullName = ''.obs;
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString nickname = ''.obs;
  RxString npwp = ''.obs;
  RxString npwpStatus = ''.obs;
  RxString email = ''.obs;
  RxString instagram = ''.obs;
  RxString linkedIn = ''.obs;
  RxString maritalStatus = ''.obs;

  List<String> listNpwpStatus = [
    'TK',
    'TK1',
    'TK2',
    'TK3',
    'K0',
    'K1',
    'K2',
    'K3',
    'K/I/0',
    'K/I/1',
    'K/I/2',
    'K/I/3',
  ];

  List<String> listMaritalStatus = [
    'Single',
    'Married',
  ];

  @override
  void onInit() {
    AppUtils.logApp(argumentData.data.personal.npwp);
    super.onInit();
  }

  void validatorButton() {
    if (npwp.value.length == 15 || npwp.value.isEmpty) {
      enableButton.value = firstName.value.isNotEmpty ||
          lastName.value.isNotEmpty ||
          nickname.value.isNotEmpty ||
          npwp.value.length == 15 ||
          npwpStatus.value.isNotEmpty ||
          email.value.isNotEmpty ||
          instagram.value.isNotEmpty ||
          linkedIn.value.isNotEmpty ||
          maritalStatus.value.isNotEmpty;
    } else if (npwp.value.length < 15) {
      enableButton.value = false;
    }
    AppUtils.logApp('${enableButton.value}');
  }

  void setEditProfileValue(FormLoginValue key, String value) {
    switch (key) {
      case FormLoginValue.firstName:
        firstName(value);
        AppUtils.logApp(firstName.value);
        break;
      case FormLoginValue.lastName:
        lastName(value);
        AppUtils.logApp(lastName.value);
        break;
      case FormLoginValue.nickname:
        nickname(value);
        AppUtils.logApp(nickname.value);
        break;
      case FormLoginValue.npwp:
        npwp(value);
        AppUtils.logApp(npwp.value);
        break;
      case FormLoginValue.npwpStatus:
        npwpStatus(value);
        AppUtils.logApp(npwpStatus.value);
        break;
      case FormLoginValue.email:
        email(value);
        AppUtils.logApp(email.value);
        break;
      case FormLoginValue.instagram:
        instagram(value);
        AppUtils.logApp(instagram.value);
        break;
      case FormLoginValue.linkedin:
        linkedIn(value);
        AppUtils.logApp(linkedIn.value);
        break;
      case FormLoginValue.maritalStatus:
        maritalStatus(value);
        AppUtils.logApp(maritalStatus.value);
        break;
    }
    validatorButton();
  }

  Future<void> editProfile() async {
    AppUtils.logApp(fullName.value);
    AppUtils.logApp(firstName.value);
    AppUtils.logApp(lastName.value);
    AppUtils.logApp(nickname.value);
    AppUtils.logApp(npwp.value);
    AppUtils.logApp(npwpStatus.value);
    AppUtils.logApp(email.value);
    AppUtils.logApp(instagram.value);
    AppUtils.logApp(linkedIn.value);

    isLoading(true);
    final r = await patchEditProfileUseCase(
      ParamsEditProfile(
        employeeParams: EmployeeParamsModel(
          employeeId: int.parse(id),
          firstName: firstName.value.isEmpty
              ? argumentData.data.personal.fullName
              : firstName.value,
          lastName: lastName.value.isEmpty
              ? argumentData.data.personal.lastName
              : lastName.value,
          nickname: nickname.value.isEmpty
              ? argumentData.data.personal.nickname
              : nickname.value,
          npwp:
              npwp.value.isEmpty ? argumentData.data.personal.npwp : npwp.value,
          npwpStatus: npwpStatus.value.isEmpty
              ? argumentData.data.personal.npwpStatus
              : npwpStatus.value,
          email: email.value.isEmpty
              ? argumentData.data.personal.personalEmail
              : email.value,
          instagram: instagram.value.isEmpty
              ? argumentData.data.personal.instagram
              : instagram.value,
          linkedIn: linkedIn.value.isEmpty
              ? argumentData.data.personal.linkedin
              : linkedIn.value,
          maritalStatus: maritalStatus.value.isEmpty
              ? argumentData.data.personal.maritalStatus.toString()
              : maritalStatus.value,
        ),
      ),
    );
    r.fold((l) {
      isLoading(false);
      AppUtils.logApp('Failure');
    }, (r) {
      isLoading(false);
      AppUtils.logApp('Success');
      Get.find<ProfileController>().setTabIndex(0);
      Get.back(result: true);
      appDialog.showSuccessSnackBar(
          description: 'Profile changes saved successfully');
    });
  }

  void setNpwpStatus(String value) {
    npwpStatus.value = value;
    validatorButton();
    AppUtils.logApp(npwpStatus.value);
  }

  void clearNpwpStatus() {
    npwpStatus.value = '';
    validatorButton();
    AppUtils.logApp(npwpStatus.value);
  }

  void setMaritalStatus(String value) {
    maritalStatus.value = value;
    validatorButton();
    AppUtils.logApp(maritalStatus.value);
  }

  void clearMaritalStatus() {
    maritalStatus.value = '';
    validatorButton();
    AppUtils.logApp(maritalStatus.value);
  }
}
