// import 'package:iroyal/app/routes/app_pages.dart';
// import 'package:iroyal/base/config/app_constants.dart';
// import 'package:iroyal/base/utils/storage/app_storage.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';

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
