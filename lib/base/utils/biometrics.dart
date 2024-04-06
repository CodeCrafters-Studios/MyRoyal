import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

abstract class AuthBiometrics {
  Future<bool> isSupported();
  Future<AuthReason> authenticate({String? description});
}

class AuthBiometricsImpl implements AuthBiometrics {
  final LocalAuthentication auth;
  AuthBiometricsImpl({
    required this.auth,
  });
  @override
  Future<AuthReason> authenticate({String? description}) async {
    final availableBiometrics = await auth.getAvailableBiometrics();

    if (availableBiometrics.isNotEmpty) {
      try {
        final didAuthenticate = await auth.authenticate(
          localizedReason: description ?? 'Please Authenticate Biometrics',
          options: const AuthenticationOptions(
            useErrorDialogs: false,
            biometricOnly: true,
          ),
        );
        return AuthReason(isAuthenticated: didAuthenticate);
      } on PlatformException catch (e) {
        if (e.code == auth_error.notAvailable) {
          // Add handling of no hardware here.
        } else if (e.code == auth_error.notEnrolled) {
          // ...
        } else {
          // ...
        }

        return AuthReason(isAuthenticated: false, reason: e.toString());
      }
    } else {
      return AuthReason(
        isAuthenticated: false,
        reason: 'Biometrics not available',
      );
    }
  }

  @override
  Future<bool> isSupported() async {
    final canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final isSupported = await auth.isDeviceSupported();

    return canAuthenticateWithBiometrics && isSupported;
  }
}

class AuthReason {
  bool isAuthenticated;
  String reason;
  AuthReason({
    required this.isAuthenticated,
    this.reason = '',
  });
}
