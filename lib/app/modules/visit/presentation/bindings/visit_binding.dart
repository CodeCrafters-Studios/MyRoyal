import 'package:get/get.dart';
import 'package:iroyal/app/modules/visit/data/datasources/local_data.dart';
import 'package:iroyal/app/modules/visit/data/repositories/visit_repository_impl.dart';
import 'package:iroyal/app/modules/visit/domain/usecases/get_locations.dart';

import '../controllers/visit_controller.dart';

class VisitBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<VisitController>(
        () => VisitController(
          getlocations: Get.find(),
        ),
      )
      ..lazyPut<VisitLocalDataSourcesImpl>(
        () => VisitLocalDataSourcesImpl(
            // httpService: Get.find(),
            ),
      )
      ..lazyPut<VisitRepositoryImpl>(
        () => VisitRepositoryImpl(
          localData: Get.find<VisitLocalDataSourcesImpl>(),
        ),
      )
      ..lazyPut(
        () => GetLocations(
          Get.find<VisitRepositoryImpl>(),
        ),
      );
  }
}
