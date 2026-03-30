import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/home/data/models/user_data_model.dart';
import 'package:MyRoyal/app/modules/home/domain/usecases/get_cache_user_usecase.dart';
import 'package:MyRoyal/app/modules/profile/data/models/personal.dart';
import 'package:MyRoyal/app/modules/profile/data/models/professional.dart';
import 'package:MyRoyal/app/modules/profile/data/models/profile_data_model.dart';
import 'package:MyRoyal/app/modules/profile/domain/entities/profile.dart';
import 'package:MyRoyal/app/modules/profile/domain/usecases/download_file.dart';
import 'package:MyRoyal/app/modules/profile/domain/usecases/get_profile.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';
import 'package:MyRoyal/base/widgets/others/ticker_provider.dart';

class ProfileController extends GetxController {
  ProfileController({
    required this.getProfile,
    required this.getCacheUser,
    required this.appDialog,
    required this.downloadFile,
  });

  late final TabController tabController;

  final GetProfile getProfile;
  final GetCacheUserUsecase getCacheUser;
  final AppDialog appDialog;
  final DownloadFile downloadFile;

  final RxBool isLoading = false.obs;

  RxInt id = 0.obs;

  String getIdState = '';
  String profileState = '';

  final Rx<Profile> profileData = Profile(
      code: 0,
      message: '',
      data: ProfileDataModel(
        personal: PersonalModel(),
        professional: const ProfessionalModel(),
        documents: const [],
      )).obs;

  final Rx<UserDataModel> userData = UserDataModel.empty().obs;

  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: TicckerProvider());
    _getCacheUser();
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
    final r = await getCacheUser();
    r.fold((l) {
      isLoading.value = false;
    }, (r) {
      AppUtils.logApp('RESPONSE CACHE USER :::: $r');
      userData.value = r;
      id.value = r.employeeId;
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

  Future<void> downloadFiles(String url, String fileName) async {
    final result = await downloadFile(
      ParamsDownload(url: url, fileName: fileName),
    );

    await result.fold(
      (failure) =>
          appDialog.showErrorSnackBar(description: 'Failed Download Document'),
      (success) async {
        await appDialog.showSuccessSnackBar(
          description: 'Success Download Document',
        );
      },
    );
  }
}
