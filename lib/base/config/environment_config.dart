import 'dart:io';

enum EnvironmentType { development, staging, production }

class EnvironmentConfig {
  const EnvironmentConfig.development()
      : environment = EnvironmentType.development,
        // androidBaseUrl = 'https://staging.royalcorp.co.id',
        // iosBaseUrl = 'https://staging.royalcorp.co.id';
        // androidBaseUrl = 'https://api.royalcorp.co.id',
        // iosBaseUrl = 'https://api.royalcorp.co.id';
        androidBaseUrl = 'https://dev-hr.royalcorp.co.id/api/',
        iosBaseUrl = 'https://dev-hr.royalcorp.co.id/api/';

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
