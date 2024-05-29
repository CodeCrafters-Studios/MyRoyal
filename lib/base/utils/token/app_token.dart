import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';

abstract class AppToken {
  Future<bool> isValid(String token);
  Future<String?> getToken();
}

class AppTokenImpl implements AppToken {
  AppTokenImpl({
    required this.appStorage,
    required this.http,
  });

  final AppStorage appStorage;
  final HttpService http;

  @override
  Future<bool> isValid(String token) async {
    var expToken = await appStorage.read(CACHE_EXPIRES_TOKEN);
    var expTokenInt = int.tryParse(expToken!);
    final int now = DateTime.now().second * 1000;
    if (expToken != '' && now > expTokenInt!) {
      return true;
    } else {
      return false;
    }
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
        final params = {
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
          'client_id': 'H4K3aPzo1VXD8JwTj7AHSayJ1fOQfUmZwSMpDu7uKmM',
          'client_secret': 'dYr3QnrIqgmflANWZLfWg3Qgh-A1dNHssQ9KprP3DTE',
        };
        try {
          final r = await http.request(params: params);
          final responseToken = r['access_token'];
          final responseRefreshToken = r['refresh_token'];

          await appStorage.write(CACHE_ACCESS_TOKEN, responseToken);
          await appStorage.write(CACHE_REFRESH_TOKEN, responseRefreshToken);
          return responseToken;
        } catch (e) {
          return null;
        }
      }
    }

    return null;
  }
}
