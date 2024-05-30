// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/services.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';

abstract class AuthBiometrics {
  Future<bool> isSupported();
  Future<AuthReason> authenticate({String? description});
}

class AuthBiometricsImpl implements AuthBiometrics {
  AuthBiometricsImpl({
    required this.auth,
    required this.appDialog,
    required this.appStorage,
  });

  final LocalAuthentication auth;
  final AppDialog appDialog;
  final AppStorage appStorage;

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
        AppUtils.logApp('PLATFORMEXCEPTION :::: v');
        if (e.code == auth_error.notAvailable) {
          // Add handling of no hardware here.
          AppUtils.logApp('BIO AUTH ERROR :::: x');
        } else if (e.code == auth_error.notEnrolled) {
          // ...
          AppUtils.logApp('BIO AUTH ERROR NOT ENROLLED :::: c');
        } else {
          // ...
          AppUtils.logApp('BIO AUTH ERROR ELSE :::: v');
        }

        return AuthReason(isAuthenticated: false, reason: e.toString());
      }
    } else {
      appStorage.write('switch-biometrics-value', 'false');
      AppUtils.logApp('ELSE BIOMETRICS :::: v');
      appDialog.showInfoDialog(
        imagePath: 'assets/icons/ic_information.svg',
        description:
            'Biometrics is not set, please configure biometrics security on your phone.',
        textButton: 'Continue',
      );
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
    final getAvailableBiometrics = await auth.getAvailableBiometrics();

    if (getAvailableBiometrics.isNotEmpty) {
      AppUtils.logApp('TRUE');
      await appStorage.write('get-available-biometrics', 'true');
    } else {
      AppUtils.logApp('FALSE');
      await appStorage.write('get-available-biometrics', 'false');
    }

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
