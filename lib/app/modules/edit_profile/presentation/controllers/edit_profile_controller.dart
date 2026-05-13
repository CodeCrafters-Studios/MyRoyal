import 'dart:io';

import 'package:MyRoyal/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:MyRoyal/app/modules/edit_profile/data/model/employee_params_model.dart';
import 'package:MyRoyal/app/modules/edit_profile/domain/usecases/patch_edit_profile.dart';
import 'package:MyRoyal/app/modules/home/data/models/user_data_model.dart';
import 'package:MyRoyal/app/modules/profile/domain/entities/profile.dart';
import 'package:MyRoyal/app/modules/profile/presentation/controllers/profile_controller.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';

enum FormLoginValue {
  firstName,
  lastName,
  nickname,
  email,
  instagram,
  linkedin,
  maritalStatus,
  birthplace,
  birthdate,
  gender,
  profilePicture,
}

class EditProfileController extends GetxController {
  EditProfileController({
    required this.patchEditProfileUseCase,
    required this.appDialog,
  });

  final PatchEditProfile patchEditProfileUseCase;
  final AppDialog appDialog;
  Profile argumentData = Get.arguments[0];
  final int id = Get.arguments[1];
  UserDataModel userData = Get.arguments[2];

  RxBool isLoading = false.obs;
  RxBool enableButton = false.obs;

  RxString fullName = ''.obs;
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString nickname = ''.obs;
  RxString email = ''.obs;
  RxString instagram = ''.obs;
  RxString linkedIn = ''.obs;
  RxString maritalStatus = ''.obs;
  RxString selectedDate = 'Select date'.obs;

  DateTime selectDate = DateTime.now();
  final ImagePicker _picker = ImagePicker();

  Rx<File?> selectedImage = Rx<File?>(null);

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
    enableButton.value = firstName.value.isNotEmpty ||
        lastName.value.isNotEmpty ||
        nickname.value.isNotEmpty ||
        email.value.isNotEmpty ||
        instagram.value.isNotEmpty ||
        linkedIn.value.isNotEmpty ||
        maritalStatus.value.isNotEmpty ||
        selectedImage.value != null;
    AppUtils.logApp('${enableButton.value}');
  }

  void setEditProfileValue(FormLoginValue key, dynamic value) {
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
      case FormLoginValue.birthdate:
        argumentData.data.personal.birthdate.toString();
        AppUtils.logApp('${argumentData.data.personal.birthdate}');
        break;
      case FormLoginValue.birthplace:
        argumentData.data.personal.birthplace;
        AppUtils.logApp(argumentData.data.personal.birthplace);
        break;
      case FormLoginValue.gender:
        argumentData.data.personal.gender;
        AppUtils.logApp(argumentData.data.personal.gender);
        break;
      case FormLoginValue.profilePicture:
        selectedImage(value);
        AppUtils.logApp('${selectedImage.value}');
        break;
    }
    validatorButton();
  }

  Future<void> saveProfile() async {
    AppUtils.logApp(fullName.value);
    AppUtils.logApp(firstName.value);
    AppUtils.logApp(lastName.value);
    AppUtils.logApp(nickname.value);
    AppUtils.logApp(email.value);
    AppUtils.logApp(instagram.value);
    AppUtils.logApp(linkedIn.value);
    AppUtils.logApp(maritalStatus.value);
    AppUtils.logApp('${argumentData.data.personal.birthdate}');
    AppUtils.logApp(argumentData.data.personal.birthplace);
    AppUtils.logApp(argumentData.data.personal.gender);
    AppUtils.logApp('${selectedImage.value}');

    isLoading(true);

    final r = await patchEditProfileUseCase(
      EmployeeParamsModel(
        employeeId: id,
        firstName: firstName.value.isEmpty
            ? argumentData.data.personal.firstName
            : firstName.value,
        lastName: lastName.value.isEmpty
            ? argumentData.data.personal.lastName
            : lastName.value,
        nickname: nickname.value.isEmpty
            ? argumentData.data.personal.nickname
            : nickname.value,
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
        birthPlace: argumentData.data.personal.birthplace,
        birthDate:
            DateFormat('dd-MM-y').format(argumentData.data.personal.birthdate),
        gender: argumentData.data.personal.gender,
        profilePicture:
            selectedImage.value == null ? '' : selectedImage.value!.path,
      ),
    );

    r.fold((l) {
      isLoading(false);
      AppUtils.logApp(l.toString());
    }, (r) {
      isLoading(false);
      AppUtils.logApp('Success');
      Get.find<ProfileController>().setTabIndex(0);
      Get.find<HomeController>().onRefresh();
      Get.back(result: true);
      appDialog.showSuccessSnackBar(
          description: 'Profile changes saved successfully');
    });
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

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
      validatorButton();
      AppUtils.logApp('Image selected: ${selectedImage.value}');
    } else {
      AppUtils.logApp('No image selected.');
      validatorButton();
    }
  }

  void clearImage() {
    selectedImage.value = null;
  }
}
