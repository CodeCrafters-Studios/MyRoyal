import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class AppPermission {
  Future<bool> requestStorage();
  Future<bool> get photoStatus;
  Future<bool> requestPhoto();
  Future<bool> get cameraStatus;
  Future<bool> requestCamera();
  Future<bool> get micStatus;
  Future<bool> requestMic();
}

class AppPermissionImpl implements AppPermission {
  @override
  Future<bool> requestStorage() async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      if ((info.version.sdkInt) >= 33) {
        return true;
      } else {
        status = await Permission.storage.request();
      }
    } else {
      status = await Permission.storage.request();
    }

    AppUtils.logApp('PermissionStatus ==== $status');

    switch (status) {
      case PermissionStatus.denied:
        return false;
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.restricted:
        return false;
      case PermissionStatus.limited:
        return true;
      case PermissionStatus.permanentlyDenied:
        return false;
      default:
        return false;
    }
  }

  @override
  Future<bool> get photoStatus => Permission.photos.isGranted;

  @override
  Future<bool> requestPhoto() async {
    final r = await Permission.photos.request();
    return r.isGranted;
  }

  @override
  Future<bool> get cameraStatus => Permission.camera.isGranted;

  @override
  Future<bool> get micStatus => Permission.microphone.isGranted;

  @override
  Future<bool> requestCamera() async {
    final r = await Permission.camera.request();
    return r.isGranted;
  }

  @override
  Future<bool> requestMic() async {
    final r = await Permission.microphone.request();
    return r.isGranted;
  }
}
