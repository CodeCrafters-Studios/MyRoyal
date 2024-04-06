import 'dart:math';

import 'package:intl/intl.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/get_device_info.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

abstract class AppToken {
  Future<bool> isValid(String token);
  Future<String?> getToken();
}

class AppTokenImpl implements AppToken {
  AppTokenImpl({
    required this.appStorage,
    required this.http,
    required this.deviceInfo,
  });

  final AppStorage appStorage;
  final HttpService http;
  final DeviceInfo deviceInfo;
  @override
  Future<bool> isValid(String token) async {
    return !JwtDecoder.isExpired(token);
  }

  @override
  Future<String?> getToken() async {
    final token = await appStorage.read(CACHE_ACCESS_TOKEN);
    final refreshToken = await appStorage.read(CACHE_REFRESH_TOKEN);

    if (token != null) {
      final isValidToken = await isValid(token);
      if (isValidToken) {
        return token;
      }
    }

    if (refreshToken != null) {
      final isValidRefreshToken = await isValid(refreshToken);
      if (isValidRefreshToken) {
        final device = await deviceInfo.info();
        final trxDateTime = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
        final sytemTraceAuditDate = DateFormat('DD').format(DateTime.now());
        final random = Random.secure();
        final systemTraceAudit =
            '$sytemTraceAuditDate${random.nextInt(1000) * 1000 + 1}';

        // final params = {
        //   'grant_type': 'password',
        //   'username': "aji.yulianto",
        //   'password': "Nginx*123#",
        //   'client_id': 'H4K3aPzo1VXD8JwTj7AHSayJ1fOQfUmZwSMpDu7uKmM',
        //   'client_secret': 'dYr3QnrIqgmflANWZLfWg3Qgh-A1dNHssQ9KprP3DTE',
        // };
        final params = {
          'pos_terminal_type': '6017',
          'trx_type': 'RET',
          'trx_date_time': trxDateTime,
          'system_trace_audit': systemTraceAudit,
          'unique_id': device.id,
          'token': refreshToken,
        };
        try {
          final r = await http.request(params: params);
          if (r['response_msg'] == 'success') {
            final responseToken = r['access_token'];
            final responseRefreshToken = r['refresh_token'];

            await appStorage.write(CACHE_ACCESS_TOKEN, responseToken);
            await appStorage.write(CACHE_REFRESH_TOKEN, responseRefreshToken);
            return responseToken;
          }
        } catch (e) {
          return null;
        }
      }
    }

    return null;
  }
}
