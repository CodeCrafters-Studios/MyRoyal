import 'package:get/get.dart';
import 'package:iroyal/app/modules/notifications/domain/entities/notification_dummy.dart';

class NotificationsController extends GetxController {
  var filterNewNotif = <NotificationsDummy>[].obs;
  var notifDummy = <NotificationsDummy>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, List<NotificationsDummy>>;
    filterNewNotif.assignAll(args['filterNewNotif'] ?? []);
    notifDummy.assignAll(args['notifDummy'] ?? []);
  }
}
