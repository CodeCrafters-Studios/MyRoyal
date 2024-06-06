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

      if (info.version.sdkInt >= 33) {
        return true; // Android 13 and above have different permission requirements.
      } else {
        status = await Permission.storage.request();
      }
    } else {
      status = await Permission.storage.request();
    }

    AppUtils.logApp('PermissionStatus ==== $status');

    return _handlePermissionStatus(status);
  }

  @override
  Future<bool> get photoStatus async => await Permission.photos.isGranted;

  @override
  Future<bool> requestPhoto() async {
    final status = await Permission.photos.request();
    return _handlePermissionStatus(status);
  }

  @override
  Future<bool> get cameraStatus async => await Permission.camera.isGranted;

  @override
  Future<bool> requestCamera() async {
    final status = await Permission.camera.request();
    return _handlePermissionStatus(status);
  }

  @override
  Future<bool> get micStatus async => await Permission.microphone.isGranted;

  @override
  Future<bool> requestMic() async {
    final status = await Permission.microphone.request();
    return _handlePermissionStatus(status);
  }

  bool _handlePermissionStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        return true;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
      default:
        return false;
    }
  }
}
