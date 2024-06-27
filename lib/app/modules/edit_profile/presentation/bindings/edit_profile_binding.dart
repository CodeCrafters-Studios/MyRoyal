import 'package:get/get.dart';
import 'package:iroyal/app/modules/edit_profile/data/datasources/edit_profile_remote.dart';
import 'package:iroyal/app/modules/edit_profile/data/repositories/edit_profile_repository_impl.dart';
import 'package:iroyal/app/modules/edit_profile/domain/usecases/patch_edit_profile.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<EditProfileController>(
        () => EditProfileController(patchEditProfileUseCase: Get.find()),
      )
      ..lazyPut<PatchEditProfile>(
        () => PatchEditProfile(Get.find()),
      )
      ..lazyPut<EditProfileRepositoryImpl>(
        () => EditProfileRepositoryImpl(remoteData: Get.find()),
      )
      ..lazyPut<EditProfileRemoteSourceImpl>(
        () => EditProfileRemoteSourceImpl(httpService: Get.find()),
      );
  }
}
