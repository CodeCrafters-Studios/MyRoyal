import 'dart:io';

enum EnvironmentType { development, staging, production }

class EnvironmentConfig {
  const EnvironmentConfig.development()
      : environment = EnvironmentType.development,
        androidBaseUrl = 'https://dev-hr.royalcorp.co.id/api/v1/',
        iosBaseUrl = 'https://dev-hr.royalcorp.co.id/api/v1/';

  const EnvironmentConfig.staging()
      : environment = EnvironmentType.staging,
        androidBaseUrl = '',
        iosBaseUrl = '';

  const EnvironmentConfig.production()
      : environment = EnvironmentType.production,
        androidBaseUrl = '',
        iosBaseUrl = '';

  final EnvironmentType environment;
  final String androidBaseUrl;
  final String iosBaseUrl;

  static late EnvironmentType environmentType;

  String get baseUrl => Platform.isIOS ? iosBaseUrl : androidBaseUrl;
}
