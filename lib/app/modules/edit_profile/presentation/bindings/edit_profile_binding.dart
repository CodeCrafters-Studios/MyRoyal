import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/edit_profile/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/edit_profile/data/repositories/edit_profile_repository_impl.dart';
import 'package:MyRoyal/app/modules/edit_profile/domain/usecases/patch_edit_profile.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<EditProfileController>(
        () => EditProfileController(
          patchEditProfileUseCase: Get.find(),
          appDialog: Get.find<AppDialogImpl>(),
        ),
      )
      ..lazyPut<PatchEditProfile>(
        () => PatchEditProfile(Get.find()),
      )
      ..lazyPut<EditProfileRepositoryImpl>(
        () => EditProfileRepositoryImpl(remoteData: Get.find()),
      )
      ..lazyPut<EditProfileRemoteSourceImpl>(
        () => EditProfileRemoteSourceImpl(
          httpService: Get.find(),
        ),
      );
  }
}
