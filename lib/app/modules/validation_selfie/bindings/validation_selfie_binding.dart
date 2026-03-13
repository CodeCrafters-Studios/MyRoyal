import 'package:get/get.dart';
import 'package:iroyal/app/modules/attendance/data/datasources/attendance_remote_data_source.dart';
import 'package:iroyal/app/modules/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:iroyal/app/modules/attendance/domain/usecases/get_attendance_location_usecase.dart';
import 'package:iroyal/app/modules/attendance/domain/usecases/get_attendance_today_usecase.dart';
import 'package:iroyal/app/modules/attendance/domain/usecases/record_attendance_usecase.dart';
import 'package:iroyal/app/modules/attendance/presentation/controllers/attendance_controller.dart';
import 'package:iroyal/base/services/http_service.dart';

import '../controllers/validation_selfie_controller.dart';

class ValidationSelfieBinding extends Bindings {
  @override
  void dependencies() {
    Get
      // Attendance
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
      )
      ..lazyPut<ValidationSelfieController>(
        () => ValidationSelfieController(
          recordAttendanceUsecase: Get.find<RecordAttendanceUsecase>(),
        ),
      );
  }
}
