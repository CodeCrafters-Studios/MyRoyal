import 'package:get/get.dart';
import 'package:iroyal/app/modules/cam_app_trace_serial/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/cam_app_trace_serial/data/repositories/trace_serial_repository_impl.dart';
import 'package:iroyal/app/modules/cam_app_trace_serial/domain/usecases/get_trace_serial_usecase.dart';

import '../controllers/cam_app_trace_serial_controller.dart';

class CamAppTraceSerialBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<TraceSerialDataSourcesImpl>(
        () => TraceSerialDataSourcesImpl(httpService: Get.find()),
      )
      ..lazyPut<TraceSerialRepositoryImpl>(
        () => TraceSerialRepositoryImpl(Get.find<TraceSerialDataSourcesImpl>()),
      )
      ..lazyPut<GetTraceSerialUsecase>(
        () => GetTraceSerialUsecase(Get.find<TraceSerialRepositoryImpl>()),
      )
      ..lazyPut<CamAppTraceSerialController>(
        () => CamAppTraceSerialController(
            getTraceSerialUsecase: Get.find<GetTraceSerialUsecase>()),
      );
  }
}
