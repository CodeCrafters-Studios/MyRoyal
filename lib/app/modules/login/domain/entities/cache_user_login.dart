import 'package:equatable/equatable.dart';

class CacheUserLogin extends Equatable {
  const CacheUserLogin({
    required this.grantType,
    required this.clientId,
    required this.clientSecret,
    required this.username,
    required this.password,
    required this.scope,
    required this.fcmToken,
    required this.deviceId,
  });

  final String grantType;
  final String clientId;
  final String clientSecret;
  final String username;
  final String password;
  final String scope;
  final String fcmToken;
  final String deviceId;

  @override
  List<Object?> get props => [
        grantType,
        clientId,
        clientSecret,
        username,
        password,
        scope,
        fcmToken,
        deviceId,
      ];
}
