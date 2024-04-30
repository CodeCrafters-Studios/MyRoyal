import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';

abstract class InitialRoute {
  Future<String> get route;
  Future<bool> get isAllowedBiometricsFingerPrint;
}

class InitialRouteImpl implements InitialRoute {
  InitialRouteImpl({required this.appStorage});

  final AppStorage appStorage;

  @override
  Future<String> get route async {
    final everLogin = await appStorage.read('ever-login');

    if (everLogin == null) {
      return Routes.SPLASH;
    }

    final token = await appStorage.read(CACHE_ACCESS_TOKEN);
    if (token == null) {
      return Routes.LOGIN;
    } else {
      final isExpired = await isTokenExpired(token);
      AppUtils.logApp('EXPIRED ::::::::: $isExpired');
      if (!isExpired) {
        return Routes.BOTTOMNAVBAR;
      } else {
        AppUtils.logApp("TOKEN IS EXPIRED");
        return Routes.LOGIN;
      }
    }
  }

  Future<bool> isTokenExpired(String token) async {
    final expiresInString = await appStorage.read(CACHE_EXPIRES_TOKEN);
    if (expiresInString != null) {
      final expiresIn = DateTime.parse(expiresInString);
      final now = DateTime.now();
      AppUtils.logApp('EXPIRE IN :::::::$expiresIn');
      AppUtils.logApp('DATETIME NOW :::::::$now');
      return now.compareTo(expiresIn) > 0;
    } else {
      AppUtils.logApp('ELSE :::::::');
      return true;
    }
  }

  @override
  Future<bool> get isAllowedBiometricsFingerPrint async {
    final fingerprintLogin = await appStorage.read('fingerprint-login');

    if (fingerprintLogin == 'false') {
      AppUtils.logApp('FINGERPRINT VALUE INITIAL :::::::NULL or FALSE');
      return false;
    } else {
      AppUtils.logApp('FINGERPRINT VALUE INITIAL :::::::TRUE');
      return true;
    }
  }
}

// abstract class InitialRoute {
//   Future<String> get route;
// }

// class InitialRouteImpl implements InitialRoute {
//   InitialRouteImpl({required this.appStorage});

//   final AppStorage appStorage;
//   @override
//   Future<String> get route async {
//     final everLogin = await appStorage.read('ever-login');

//     if (everLogin == null) {
//       return Routes.SPLASH;
//     }

//     final token = await appStorage.read(CACHE_ACCESS_TOKEN);
//     if (token == null) {
//       return Routes.LOGIN;
//     } else {
//       final isExpired = JwtDecoder.isExpired(token);
//       if (!isExpired) {
//         return Routes.HOME;
//       } else {
//         return Routes.LOGIN;
//       }
//     }
//   }
// }