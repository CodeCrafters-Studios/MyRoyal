import 'dart:io';

enum EnvironmentType { development, staging, production }

class EnvironmentConfig {
  const EnvironmentConfig.development()
      : environment = EnvironmentType.development,
        androidBaseUrl = 'https://apiems.royalcorp.co.id/api/v1/',
        iosBaseUrl = 'https://dev-api.royalcorp.co.id/api/v1/';

  const EnvironmentConfig.production()
      : environment = EnvironmentType.production,
        androidBaseUrl = 'https://apiems.royalcorp.co.id/api/v1/',
        iosBaseUrl = 'https://apiems.royalcorp.co.id/api/v1/';

  final EnvironmentType environment;
  final String androidBaseUrl;
  final String iosBaseUrl;

  static late EnvironmentType environmentType;

  String get baseUrl => Platform.isIOS ? iosBaseUrl : androidBaseUrl;
}
