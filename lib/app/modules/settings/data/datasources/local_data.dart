import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';

abstract class SettingsLocalData {
  Future<bool> logout();
  Future<bool> biometrics();
}

class SettingsLocalDataImpl implements SettingsLocalData {
  SettingsLocalDataImpl({required this.appStorage, required this.appDialog});

  final AppStorage appStorage;
  final AppDialog appDialog;
  @override
  Future<bool> logout() async {
    final confirm = await appDialog.showChoiceDialog(
        description: 'Are you sure to exit app?');
    if (confirm) {
      await appStorage.delete(CACHE_ACCESS_TOKEN);
      await appStorage.delete(CACHE_REFRESH_TOKEN);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> biometrics() async {
    final confirm = await appDialog.showChoiceDialog(
        description: 'Are you sure to allow app using biometrics?');
    if (confirm) {
      await appStorage.read('fingerprint-login');
      return true;
    } else {
      return false;
    }
  }
}
