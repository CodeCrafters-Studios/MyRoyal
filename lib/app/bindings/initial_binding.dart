import 'package:MyRoyal/app/modules/attendance/presentation/views/components/attendance_reminder_service.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/controllers/user_info_controller.dart';
import 'package:MyRoyal/app/controllers/utility_controller.dart';
import 'package:MyRoyal/app/shared/data/datasources/local_data.dart';
import 'package:MyRoyal/app/shared/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/shared/data/repositories/global_repository_impl.dart';
import 'package:MyRoyal/app/shared/domain/usecases/get_cache_login.dart';

class InitialBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    Get
      ..put(UserInfoController())
      ..put(UtilityController())

      //GLOBAL
      ..put(GlobalLocalDataImpl(appStorage: Get.find()))
      ..put(
        GlobalRemoteDataImpl(
          http: Get.find(),
          appStorage: Get.find(),
        ),
      )
      ..put(
        GlobalRepositoryImpl(
          localData: Get.find<GlobalLocalDataImpl>(),
          remoteData: Get.find<GlobalRemoteDataImpl>(),
        ),
      )
      ..put(GetCacheLogin(Get.find<GlobalRepositoryImpl>()))
      ..put(() => AttendanceReminderService.instance);
  }
}
