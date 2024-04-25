import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';

abstract class ProfileLocalData {
  Future<bool> logout();
}

class ProfileLocalDataImpl implements ProfileLocalData {
  ProfileLocalDataImpl({required this.appStorage, required this.appDialog});

  final AppStorage appStorage;
  final AppDialog appDialog;
  @override
  Future<bool> logout() async {
    final confirm = await appDialog.showChoiceDialog(description: 'Exit App');
    if (confirm) {
      await appStorage.delete(CACHE_ACCESS_TOKEN);
      await appStorage.delete(CACHE_REFRESH_TOKEN);
      return true;
    } else {
      return false;
    }
  }
}
