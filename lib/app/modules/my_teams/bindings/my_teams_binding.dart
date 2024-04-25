import 'package:get/get.dart';

import '../controllers/my_teams_controller.dart';

class MyTeamsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyTeamsController>(
      () => MyTeamsController(),
    );
  }
}
