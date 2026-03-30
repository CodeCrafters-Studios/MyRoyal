import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/attendance/data/datasources/attendance_remote_data_source.dart';
import 'package:MyRoyal/app/modules/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:MyRoyal/app/modules/attendance/domain/usecases/get_attendance_location_usecase.dart';
import 'package:MyRoyal/app/modules/attendance/domain/usecases/get_attendance_today_usecase.dart';
import 'package:MyRoyal/app/modules/attendance/domain/usecases/record_attendance_usecase.dart';
import 'package:MyRoyal/base/services/http_service.dart';

import '../controllers/attendance_controller.dart';

class AttendanceBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<AttendanceRemoteDataSourceImpl>(
        () => AttendanceRemoteDataSourceImpl(
          httpService: Get.find<HttpService>(),
        ),
      )
      ..lazyPut<AttendanceRepositoryImpl>(
        () => AttendanceRepositoryImpl(
            remoteDataSource: Get.find<AttendanceRemoteDataSourceImpl>()),
      )
      ..lazyPut<RecordAttendanceUsecase>(
        () => RecordAttendanceUsecase(
          repository: Get.find<AttendanceRepositoryImpl>(),
        ),
      )
      ..lazyPut<GetAttendanceTodayUsecase>(
        () => GetAttendanceTodayUsecase(
          repository: Get.find<AttendanceRepositoryImpl>(),
        ),
      )
      ..lazyPut<GetAttendanceLocationUsecase>(
        () => GetAttendanceLocationUsecase(
          repository: Get.find<AttendanceRepositoryImpl>(),
        ),
      )
      ..lazyPut<AttendanceController>(
        () => AttendanceController(
          getAttendanceTodayUsecase: Get.find<GetAttendanceTodayUsecase>(),
          recordAttendanceUsecase: Get.find<RecordAttendanceUsecase>(),
          getAttendanceLocationUsecase:
              Get.find<GetAttendanceLocationUsecase>(),
        ),
      );
  }
}
