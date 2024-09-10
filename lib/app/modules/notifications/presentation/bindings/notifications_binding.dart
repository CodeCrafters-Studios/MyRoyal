import 'package:get/get.dart';
import 'package:iroyal/app/modules/notifications/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:iroyal/app/modules/notifications/domain/usecases/get_notifications.dart';
import 'package:iroyal/app/modules/notifications/domain/usecases/tap_notification.dart';

import '../controllers/notifications_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get
      //Profile
      ..lazyPut<NotificationsController>(
        () => NotificationsController(
            getNotifications: Get.find(), tapNotification: Get.find()),
      )
      ..lazyPut<NotificationsRemoteDataSourcesImpl>(
        () => NotificationsRemoteDataSourcesImpl(
          httpService: Get.find(),
        ),
      )
      ..lazyPut<NotificationsRepositoryImpl>(
        () => NotificationsRepositoryImpl(
          remoteData: Get.find<NotificationsRemoteDataSourcesImpl>(),
        ),
      )
      ..lazyPut(
        () => GetNotifications(
          Get.find<NotificationsRepositoryImpl>(),
        ),
      )
      ..lazyPut(
        () => TapNotification(
          Get.find<NotificationsRepositoryImpl>(),
        ),
      );
  }
}
