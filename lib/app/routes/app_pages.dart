import 'package:get/get.dart';

import '../modules/bottomnavbar/presentation/bindings/bottomnavbar_binding.dart';
import '../modules/bottomnavbar/presentation/views/bottomnavbar_view.dart';
import '../modules/home/presentation/bindings/home_binding.dart';
import '../modules/home/presentation/views/home_view.dart';
import '../modules/login/presentation/bindings/login_binding.dart';
import '../modules/login/presentation/views/login_view.dart';
import '../modules/my_teams/presentation/bindings/my_teams_binding.dart';
import '../modules/my_teams/presentation/views/my_teams_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.BOTTOMNAVBAR,
      page: () => const BottomnavbarView(),
      binding: BottomnavbarBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.MY_TEAMS,
      page: () => const MyTeamsView(),
      binding: MyTeamsBinding(),
    ),
  ];
}
