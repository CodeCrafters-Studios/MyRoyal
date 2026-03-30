import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/online_app/cam/cam_app_trace_serial/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/online_app/cam/cam_app_trace_serial/data/repositories/trace_serial_repository_impl.dart';
import 'package:MyRoyal/app/modules/online_app/cam/cam_app_trace_serial/domain/usecases/get_trace_serial_usecase.dart';

import '../controllers/ras_app_trace_serial_controller.dart';

class RasAppTraceSerialBinding extends Bindings {
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
      ..lazyPut<RasAppTraceSerialController>(
        () => RasAppTraceSerialController(
            getTraceSerialUsecase: Get.find<GetTraceSerialUsecase>()),
      );
  }
}
