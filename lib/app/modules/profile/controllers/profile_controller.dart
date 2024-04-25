import 'package:get/get.dart';
import 'package:iroyal/app/modules/profile/domain/usecases/logout_app.dart';
import 'package:iroyal/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  ProfileController({required this.logoutApp});

  final LogoutApp logoutApp;

  Future<void> cLogout() async {
    final result = await logoutApp();
    result.fold((l) => null, (r) {
      if (r) {
        Get.offAllNamed(Routes.LOGIN);
      }
    });
  }
}
