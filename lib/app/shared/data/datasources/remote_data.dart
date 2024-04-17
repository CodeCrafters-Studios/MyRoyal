import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';

abstract class GlobalRemoteData {
  Future<bool> verifyToken(String token);
  Future<String> getRefreshToken();
}

class GlobalRemoteDataImpl implements GlobalRemoteData {
  GlobalRemoteDataImpl({
    // required this.commonParam,
    required this.http,
    required this.appStorage,
    // required this.deviceInfo,
  });

  // final CommonParam commonParam;
  final HttpService http;
  final AppStorage appStorage;
  // final DeviceInfo deviceInfo;

  @override
  Future<bool> verifyToken(String token) async {
    return false;
    // final cp = await commonParam.commonParams;
    // final params = {
    //   'trx_type': 'VER',
    //   ...cp,
    // };

    // try {
    //   final r = await http.request(params: params);
    //   return r['response_msg'] == 'success';
    // } on ApiException {
    //   rethrow;
    // }
  }

  @override
  Future<String> getRefreshToken() async {
    return '';
    // final refreshToken = await appStorage.read(CACHE_REFRESH_TOKEN);
    // final device = await deviceInfo.info();

    // final params = {
    //   'pos_terminal_type': '6017',
    //   'trx_type': 'RET',
    //   'trx_date_time': commonParam.trxDateTime,
    //   'system_trace_audit': commonParam.systemTraceAudit,
    //   'unique_id': device.id,
    //   'token': refreshToken,
    // };
    // params['token'] = refreshToken;

    // try {
    //   final r = await http.request(params: params);
    //   if (r['response_msg'] == 'success') {
    //     final responseToken = r['token'];
    //     final responseRefreshToken = r['refresh_token'];

    //     await appStorage.write(CACHE_ACCESS_TOKEN, responseToken);
    //     await appStorage.write(CACHE_REFRESH_TOKEN, responseRefreshToken);
    //     return responseToken;
    //   } else {
    //     throw ApiException(r['response_msg'] ?? 'Failed Get Refresh Token');
    //   }
    // } on ApiException {
    //   rethrow;
    // }
  }
}
