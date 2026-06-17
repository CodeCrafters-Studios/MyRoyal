import 'package:get/get.dart';
import 'package:MyRoyal/base/utils/storage/app_storage.dart';
import 'package:uuid/uuid.dart';

class AppDeviceId {
  static const String _deviceIdKey = 'unique_app_device_id';
  static final Uuid _uuid = Uuid();
  static final AppStorage appStorage = AppStorage(box: Get.find());

  static Future<String> getDeviceId() async {
    String? deviceId = await appStorage.read(_deviceIdKey);

    if (deviceId == null || deviceId.isEmpty) {
      deviceId = _uuid.v4();
      await appStorage.write(_deviceIdKey, deviceId);
    }
    return deviceId;
  }
}
