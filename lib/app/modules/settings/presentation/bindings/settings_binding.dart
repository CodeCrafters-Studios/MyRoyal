import 'package:get/get.dart';
import 'package:iroyal/app/modules/help-and-support/controllers/help_and_support_controller.dart';
import 'package:iroyal/app/modules/profile/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/profile/data/repositories/profile_repository_impl.dart';
import 'package:iroyal/app/modules/profile/domain/usecases/get_profile.dart';
import 'package:iroyal/app/modules/profile/presentation/controllers/profile_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get
      //Profile
      ..lazyPut<ProfileController>(
        () => ProfileController(
          getProfile: Get.find(),
          getUser: Get.find(),
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
