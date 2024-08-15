import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/data/models/user_data.dart';
import 'package:iroyal/app/modules/home/domain/entities/user.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_cache_user.dart';
import 'package:iroyal/app/modules/profile/data/models/personal.dart';
import 'package:iroyal/app/modules/profile/data/models/professional.dart';
import 'package:iroyal/app/modules/profile/data/models/profile_data_model.dart';
import 'package:iroyal/app/modules/profile/domain/entities/profile.dart';
import 'package:iroyal/app/modules/profile/domain/usecases/download_file.dart';
import 'package:iroyal/app/modules/profile/domain/usecases/get_profile.dart';
import 'package:iroyal/base/usecases/usecase.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/widgets/others/ticker_provider.dart';

class ProfileController extends GetxController {
  ProfileController({
    required this.getProfile,
    required this.getCacheUser,
    required this.appDialog,
    required this.downloadFile,
  });

  late final TabController tabController;

  final GetProfile getProfile;
  final GetCacheUser getCacheUser;
  final AppDialog appDialog;
  final DownloadFile downloadFile;

  final RxBool isLoading = false.obs;

  RxString id = ''.obs;

  String getIdState = '';
  String profileState = '';

  final Rx<Profile> profileData = Profile(
      status: false,
      code: 0,
      message: '',
      data: ProfileDataModel(
          personal: PersonalModel(
            fullName: '',
            firstName: '',
            lastName: '',
            birthdate: DateTime(0),
            gender: '',
            maritalStatus: '',
            nickname: '',
            birthplace: '',
            instagram: '',
            linkedin: '',
            npwp: '',
            npwpStatus: '',
            personalEmail: '',
          ),
          professional: const ProfessionalModel(
            idCard: '',
            employeeNumber: '',
            reaminingLeave: 0,
            bpjsKesehatan: '',
            bpjsKetenagakerjaan: '',
            workEmail: '',
            position: '',
            department: '',
            joinDate: '',
            reportTo: '',
          ))).obs;

  final Rx<User> userData = const User(
      status: false,
      code: 0,
      message: '',
      data: UserDataModel(
        employeeId: 0,
        email: '',
        fullName: '',
        employeeNumber: '',
        position: '',
        department: '',
        joinDate: '',
        initialName: '',
        profilePicture: '',
      )).obs;

  @override
  void onInit() async {
    tabController = TabController(length: 3, vsync: TicckerProvider());
    await _getCacheUser();
    _getProfileData();
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> refreshProfile() async {
    await _getProfileData();
  }

  void setTabIndex(int index) {
    tabController.index = index;
  }

  Future<void> _getCacheUser() async {
    isLoading.value = true;
    final r = await getCacheUser(NoParams());
    r.fold((l) {
      isLoading.value = false;
      AppUtils.logApp(l.toString());
    }, (r) {
      isLoading.value = false;
      AppUtils.logApp('RESPONSE CACHE USER :::: $r');
      AppUtils.logApp('ID CACHE USER :::: ${r.data.employeeId}');
      userData.value = r;
      id.value = r.data.employeeId.toString();
    });
  }

  Future<void> _getProfileData() async {
    isLoading.value = true;

    final result = await getProfile();

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

  Future<void> downloadPdf() async {
    isLoading(true);
    const url = 'https://www.tutorialspoint.com/flutter/flutter_tutorial.pdf';
    final result = await downloadFile(url);
    isLoading(false);

    await result.fold(
      (failure) =>
          appDialog.showErrorSnackBar(description: 'failed_download_pdf'.tr),
      (success) async {
        await appDialog.showSuccessSnackBar(
          description: 'success_download_pdf',
        );
      },
    );
  }
}
