import 'package:intl/intl.dart';
import 'package:MyRoyal/base/config/environment_config.dart';

class AppConfig {
  static late EnvironmentConfig environment;

  static void loadEnvironment(String env) {
    switch (env) {
      case 'production':
        environment = const EnvironmentConfig.production();
        break;
      case 'development':
      default:
        environment = const EnvironmentConfig.development();
        break;
    }
  }

  static double get iAppBarHeight => 60;
  static set iAppBarHeight(double v) {}

  static double get iPadding => 16;
  static set iPadding(double v) {}

  static String get fontFamily => 'Montserrat';
  static set fontFamily(String v) {}

  static String get fileName =>
      'I-ROYAL-${DateFormat('ddMMyyyyHHmmss').format(DateTime.now())}';
}
