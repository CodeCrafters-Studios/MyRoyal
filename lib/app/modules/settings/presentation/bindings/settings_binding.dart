import 'package:get/get.dart';
import 'package:iroyal/app/modules/help_and_support/controllers/help_and_support_controller.dart';
import 'package:iroyal/app/modules/profile/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/profile/data/repositories/profile_repository_impl.dart';
import 'package:iroyal/app/modules/profile/domain/usecases/get_profile.dart';
import 'package:iroyal/app/modules/profile/presentation/controllers/profile_controller.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get
      //Profile
      ..lazyPut<ProfileController>(
        () => ProfileController(
          getProfile: Get.find(),
          getUser: Get.find(),
          appDialog: Get.find<AppDialogImpl>(),
        ),
      )
      ..lazyPut<ProfileRemoteDataSourcesImpl>(
        () => ProfileRemoteDataSourcesImpl(
          httpService: Get.find(),
        ),
      )
      ..lazyPut<ProfileRepositoryImpl>(
        () => ProfileRepositoryImpl(
          remoteData: Get.find<ProfileRemoteDataSourcesImpl>(),
        ),
      )
      ..lazyPut(
        () => GetProfile(
          Get.find<ProfileRepositoryImpl>(),
        ),
      )

      // Help & Support
      ..lazyPut<HelpAndSupportController>(
        () => HelpAndSupportController(),
      );
  }
}
