import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/domain/entities/job.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_user.dart';
import 'package:iroyal/app/modules/profile/domain/entities/profile.dart';
import 'package:iroyal/app/modules/profile/domain/usecases/download_file.dart';
import 'package:iroyal/app/modules/profile/domain/usecases/get_profile.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/widgets/others/ticker_provider.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';

class ProfileController extends GetxController {
  ProfileController({
    required this.getProfile,
    required this.getUser,
    required this.appDialog,
    required this.downloadFile,
  });

  late final TabController tabController;

  final GetProfile getProfile;
  final GetUser getUser;
  final AppDialog appDialog;
  final DownloadFile downloadFile;

  final RxBool isLoading = false.obs;

  RxString id = ''.obs;
  RxString status = ''.obs;

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

  final Rx<Job> jobData = const Job(
    company: '',
    department: '',
    section: '',
    position: '',
    joinDate: '',
    absenceNumber: '',
    workEmail: '',
    employeeNumber: '',
  ).obs;

  @override
  void onInit() async {
    tabController = TabController(length: 3, vsync: TicckerProvider());
    await _getIdCacheUser();
    await _getProfileData();
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> _getIdCacheUser() async {
    isLoading.value = true;
    final r = await getUser();
    r.fold(
      (l) {
        isLoading.value = false;
        getIdState = 'getIdRejected';
      },
      (r) {
        isLoading.value = false;
        getIdState = 'getIdSuccess';
        id(r.employee.id.toString());
        status(r.employee.maritalStatus);
        jobData(r.job);
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

  Future<void> downloadPdf() async {
    isLoading(true);
    const url =
        'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';
    final result = await downloadFile(url);
    isLoading(false);

    await result.fold(
        (failure) =>
            appDialog.showErrorSnackBar(description: 'failed_download_pdf'.tr),
        (success) async {
      await appDialog.showInfoSnackbar(
        description: 'success_download_pdf',
        title: 'success',
      );
      // final directory = await getExternalStorageDirectory();
      // if (directory != null) {
      //   final savePath = '${directory.path}/downloaded_file.pdf';
      //   OpenFile.open(savePath);
      // }
    });
  }
}
