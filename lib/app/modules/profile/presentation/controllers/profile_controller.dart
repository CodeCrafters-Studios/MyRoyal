import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/domain/entities/job.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_user.dart';
import 'package:iroyal/app/modules/profile/domain/entities/profile.dart';
import 'package:iroyal/app/modules/profile/domain/usecases/get_profile.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/widgets/others/ticker_provider.dart';

class ProfileController extends GetxController {
  ProfileController({
    required this.getProfile,
    required this.getUser,
    required this.appDialog,
  });

  late final TabController tabController;

  final GetProfile getProfile;
  final GetUser getUser;
  final AppDialog appDialog;

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

  // Future<void> donwloadDocuments() async {
  //   isLoading(true);
  //   final image = await screenshotController.capture();
  //   isLoading(false);
  //   if (image != null) {
  //     isLoading(true);
  //     await saveGallery(image);
  //     isLoading(false);
  //     unawaited(
  //       appDialog.showInfoSnackbar(
  //         description: 'success_save_resi'.tr,
  //         title: 'success_saved'.tr,
  //         assetIcon: 'assets/icons/ic_file.png',
  //       ),
  //     );
  //   }
  // }
}
