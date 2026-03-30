import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/check_password/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/check_password/data/repositories/check_password_repository_impl.dart';
import 'package:MyRoyal/app/modules/check_password/domain/usecases/check_password_usecase.dart';
import 'package:MyRoyal/base/services/http_service.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';

import '../controllers/check_password_controller.dart';

class CheckPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<CheckPasswordRemoteDataSourceImpl>(
        () => CheckPasswordRemoteDataSourceImpl(
          httpService: Get.find<HttpService>(),
        ),
      )
      ..lazyPut<CheckPasswordRepositoryImpl>(
        () => CheckPasswordRepositoryImpl(
          Get.find<CheckPasswordRemoteDataSourceImpl>(),
        ),
      )
      ..lazyPut<CheckPasswordUsecase>(
        () => CheckPasswordUsecase(
          Get.find<CheckPasswordRepositoryImpl>(),
        ),
      )
      ..lazyPut<CheckPasswordController>(
        () => CheckPasswordController(
          checkPasswordUsecase: Get.find<CheckPasswordUsecase>(),
          appDialog: Get.find<AppDialogImpl>(),
        ),
      );
  }
}
