import 'package:permission_handler/permission_handler.dart';

abstract class AppPermission {
  Future<bool> get storageStatus;
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
    final r = await Permission.storage.request();
    return r.isGranted;
  }

  @override
  Future<bool> get storageStatus => Permission.storage.isGranted;

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
