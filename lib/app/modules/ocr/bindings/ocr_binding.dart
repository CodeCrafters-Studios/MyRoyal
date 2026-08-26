import 'package:MyRoyal/app/modules/ocr/domain/usecases/get_data_master_employee_os_usecase.dart';
import 'package:MyRoyal/app/modules/ocr/domain/usecases/get_employee_os_usecase.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/base/services/http_service.dart';

import '../controllers/ocr_controller.dart';
import '../data/datasources/ocr_remote_data_source.dart';
import '../data/repositories/ocr_repository_impl.dart';
import '../domain/repositories/ocr_repository.dart';
import '../domain/usecases/scan_ocr_usecase.dart';
import '../domain/usecases/save_employee_os_usecase.dart';

class OcrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OcrRemoteDataSource>(
      () => OcrRemoteDataSourceImpl(httpService: Get.find<HttpService>()),
    );
    Get.lazyPut<OcrRepository>(
      () =>
          OcrRepositoryImpl(remoteDataSource: Get.find<OcrRemoteDataSource>()),
    );
    Get.lazyPut<ScanOcrUseCase>(
      () => ScanOcrUseCase(Get.find<OcrRepository>()),
    );
    Get.lazyPut<GetEmployeeOsUsecase>(
      () => GetEmployeeOsUsecase(Get.find<OcrRepository>()),
    );
    Get.lazyPut<GetDataMasterEmployeeOsUsecase>(
      () =>
          GetDataMasterEmployeeOsUsecase(repository: Get.find<OcrRepository>()),
    );
    Get.lazyPut<SaveEmployeeOsUsecase>(
      () => SaveEmployeeOsUsecase(repository: Get.find<OcrRepository>()),
    );
    Get.lazyPut<OcrController>(
      () => OcrController(
          scanOcrUseCase: Get.find<ScanOcrUseCase>(),
          saveEmployeeOsUsecase: Get.find<SaveEmployeeOsUsecase>(),
          Get.find<GetEmployeeOsUsecase>(),
          Get.find<GetDataMasterEmployeeOsUsecase>()),
    );
  }
}
