import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/edit_profile/data/model/employee_params_model.dart';
import 'package:iroyal/app/modules/edit_profile/domain/usecases/patch_edit_profile.dart';
import 'package:iroyal/app/modules/profile/domain/entities/profile.dart';
import 'package:iroyal/app/modules/profile/presentation/controllers/profile_controller.dart';
import 'package:iroyal/base/utils/app_utils.dart';

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
  });

  final PatchEditProfile patchEditProfileUseCase;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController npwpController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool enableButton = false.obs;

  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString nickname = ''.obs;
  RxString npwp = ''.obs;
  RxString npwpStatus = ''.obs;
  RxString email = ''.obs;
  RxString instagram = ''.obs;
  RxString linkedIn = ''.obs;
  RxString maritalStatus = ''.obs;

  Profile argumentData = Get.arguments;

  List<String> listNpwpStatus = [
    'TK0',
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
    AppUtils.logApp(argumentData.personal.npwp);
    super.onInit();
  }

  void validatorButton() {
    enableButton.value = firstName.value.isNotEmpty ||
        lastName.value.isNotEmpty ||
        nickname.value.isNotEmpty ||
        npwp.value.length == 15 ||
        npwpStatus.value.isNotEmpty ||
        email.value.isNotEmpty ||
        instagram.value.isNotEmpty ||
        linkedIn.value.isNotEmpty ||
        maritalStatus.value.isNotEmpty;
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

  Future<void> patchEditProfile() async {
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
          firstName: firstName.value.isEmpty
              ? argumentData.personal.fullName
              : firstName.value,
          lastName: lastName.value.isEmpty
              ? argumentData.personal.lastName
              : lastName.value,
          nickname: nickname.value.isEmpty
              ? argumentData.personal.nickname
              : nickname.value,
          npwp: npwp.value.isEmpty ? argumentData.personal.npwp : npwp.value,
          npwpStatus: npwpStatus.value.isEmpty
              ? argumentData.personal.npwpStatus
              : npwpStatus.value,
          email: email.value.isEmpty
              ? argumentData.personal.personalEmail
              : email.value,
          instagram: instagram.value.isEmpty
              ? argumentData.personal.instagram
              : instagram.value,
          linkedIn: linkedIn.value.isEmpty
              ? argumentData.personal.linkedin
              : linkedIn.value,
          maritalStatus: maritalStatus.value.isEmpty
              ? argumentData.personal.maritalStatus.toString()
              : maritalStatus.value,
        ),
        id: argumentData.personal.id.toString(),
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
