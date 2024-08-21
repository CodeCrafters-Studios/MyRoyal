import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';

abstract class GlobalRemoteData {
  Future<bool> verifyToken(String token);
}

class GlobalRemoteDataImpl implements GlobalRemoteData {
  GlobalRemoteDataImpl({
    required this.http,
    required this.appStorage,
    // required this.deviceInfo,
  });

  final HttpService http;
  final AppStorage appStorage;
  // final DeviceInfo deviceInfo;

  @override
  Future<bool> verifyToken(String token) async {
    return false;
  }
}
