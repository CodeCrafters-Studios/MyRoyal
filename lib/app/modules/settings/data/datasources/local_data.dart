import 'package:MyRoyal/base/config/app_constants.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';
import 'package:MyRoyal/base/utils/storage/app_storage.dart';

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
      buttonColor: red,
      description: 'Are you sure to exit app?',
    );
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
    // Check value for dialog message enable or disable

    final fingerPrintValue = await appStorage.read('switch-biometrics-value');
    AppUtils.logApp(fingerPrintValue.toString());
    final confirm = await appDialog.showChoiceDialog(
        description: fingerPrintValue == 'true'
            ? 'Are you sure to disable app using biometrics?'
            : 'Are you sure to enable app using biometrics?');
    if (confirm) {
      fingerPrintValue;
      return true;
    } else {
      return false;
    }
  }
}
