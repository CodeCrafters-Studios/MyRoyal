import 'package:intl/intl.dart';
import 'package:iroyal/base/config/environment_config.dart';

class AppConfig {
  static EnvironmentConfig get environment =>
      const EnvironmentConfig.development();
  static set environment(EnvironmentConfig env) {}

  static double get iAppBarHeight => 60;
  static set iAppBarHeight(double v) {}

  static double get iPadding => 16;
  static set iPadding(double v) {}

  static String get fontFamily => 'Montserrat';
  static set fontFamily(String v) {}

  static String get fileName =>
      'I-ROYAL-${DateFormat('ddMMyyyyHHmmss').format(DateTime.now())}';
}
