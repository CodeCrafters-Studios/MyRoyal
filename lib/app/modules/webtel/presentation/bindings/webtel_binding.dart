import 'package:get/get.dart';
import 'package:iroyal/app/modules/webtel/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/webtel/data/repositories/webtel_repository_impl.dart';
import 'package:iroyal/app/modules/webtel/domain/usecases/get_webtel.dart';

import '../controllers/webtel_controller.dart';

class WebtelBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<WebtelController>(
        () => WebtelController(
          getWebtel: Get.find(),
        ),
      )
      ..lazyPut<WebtelRemoteDataSourcesImpl>(
        () => WebtelRemoteDataSourcesImpl(
          httpService: Get.find(),
        ),
      )
      ..lazyPut<WebtelRepositoryImpl>(
        () => WebtelRepositoryImpl(
          remoteData: Get.find<WebtelRemoteDataSourcesImpl>(),
        ),
      )
      ..lazyPut(
        () => GetWebtel(
          Get.find<WebtelRepositoryImpl>(),
        ),
      );
  }
}
