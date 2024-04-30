import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:iroyal/app/modules/login/data/models/cache_user_login.dart';
import 'package:iroyal/app/modules/login/data/models/login_params.dart';
import 'package:iroyal/app/modules/login/data/models/login_response.dart';
import 'package:iroyal/app/modules/login/domain/entities/cache_user_login.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/biometrics.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/utils/location/app_location.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';

abstract class LoginLocalDataSource {
  Future<void> cacheLoginResponse(LoginResponseModel loginResponse);
  Future<LoginResponseModel> getCacheLoginResponse();
  Future<void> cacheUserLogin(CacheUserLoginModel user);
  Future<CacheUserLogin> getCacheUserLogin();
  Future<LoginParamsModel> getLoginParams({
    required String grantType,
    required String username,
    required String password,
    required String clientId,
    required String clientSecret,
  });
  Future<bool> authBiometrics();
  Future<void> saveLoginToken(
    String token,
    String refreshToken,
    int expiresin,
  );
}

class LoginLocalDataSourceImpl implements LoginLocalDataSource {
  LoginLocalDataSourceImpl({
    // required this.deviceInfo,
    required this.biometrics,
    required this.appStorage,
    required this.appLocation,
    // required this.commonParam,
    required this.appDialog,
  });

  final AuthBiometrics biometrics;
  final AppStorage appStorage;
  // final DeviceInfo deviceInfo;
  final AppLocation appLocation;
  // final CommonParam commonParam;
  final AppDialog appDialog;

  @override
  Future<void> cacheLoginResponse(LoginResponseModel loginResponse) {
    final jsonString = jsonEncode(loginResponse.toJson());
    return appStorage.write(
      CACHE_LOGIN_RESPONSE,
      jsonString,
    );
  }

  @override
  Future<void> cacheUserLogin(CacheUserLoginModel user) {
    return appStorage.write(CACHE_USER_LOGIN, jsonEncode(user.toJson()));
  }

  @override
  Future<LoginResponseModel> getCacheLoginResponse() async {
    final jsonString = await appStorage.read(CACHE_LOGIN_RESPONSE);
    if (jsonString != null) {
      return LoginResponseModel.fromJson(jsonDecode(jsonString));
    } else {
      throw CacheException('Data Not Found');
    }
  }

  @override
  Future<CacheUserLogin> getCacheUserLogin() async {
    final jsonString = await appStorage.read(CACHE_USER_LOGIN);
    if (jsonString != null) {
      return CacheUserLoginModel.fromJson(jsonDecode(jsonString));
    } else {
      throw CacheException('Data Not Found');
    }
  }

  @override
  Future<LoginParamsModel> getLoginParams({
    required String grantType,
    required String username,
    required String password,
    required String clientId,
    required String clientSecret,
  }) async {
    if (username.isEmpty || password.isEmpty) {
      throw LocalDataException('Username or Password cannot be empty');
    }
    final permissionStatus = await appLocation.permission;
    if (permissionStatus == LocationPermission.denied ||
        permissionStatus == LocationPermission.unableToDetermine) {
      final showDialogPermission = await appDialog.showPermissionDialog(
        description: 'App request to access device Location',
      );

      if (showDialogPermission) {
        final result = await appLocation.requestPermission();
        if (result == LocationPermission.whileInUse ||
            result == LocationPermission.always) {
          return loginParam(
            grantType,
            username,
            password,
            clientId,
            clientSecret,
          );
        } else {
          throw LocalDataException('Permission Denied');
        }
      } else {
        throw LocalDataException('Permission Denied');
      }
    } else if (permissionStatus == LocationPermission.deniedForever) {
      throw LocalDataException('Permission Denied');
    } else if (permissionStatus == LocationPermission.always ||
        permissionStatus == LocationPermission.whileInUse) {
      return loginParam(
        grantType,
        username,
        password,
        clientId,
        clientSecret,
      );
    } else {
      throw LocalDataException('Permission Denied');
    }
  }

  @override
  Future<bool> authBiometrics() async {
    if (await biometrics.isSupported()) {
      final authReason = await biometrics.authenticate();
      if (authReason.isAuthenticated) {
        return true;
      } else {
        throw BiometricsException(authReason.reason);
      }
    } else {
      throw BiometricsException('Biometrics not available');
    }
  }

  Future<LoginParamsModel> loginParam(
    final String grantType,
    final String username,
    final String password,
    final String clientId,
    final String clientSecret,
  ) async {
    // final info = await deviceInfo.info();
    // final position = await appLocation.position;
    // final latlong = '${position.latitude}, ${position.longitude}';

    return LoginParamsModel(
      grantType: grantType,
      username: username,
      password: password,
      clientId: clientId,
      clientSecret: clientSecret,
    );
  }

  @override
  Future<void> saveLoginToken(
      String token, String refreshToken, int expiresToken) async {
    await appStorage.write('ever-login', 'true');
    await appStorage.write(CACHE_ACCESS_TOKEN, token);
    await appStorage.write(CACHE_REFRESH_TOKEN, refreshToken);
    await appStorage.write(CACHE_EXPIRES_TOKEN, expiresToken.toString());
    final now = DateTime.now();
    // final expiresIn = appStorage.read(CACHE_EXPIRES_TOKEN);
    // final convertExp = int.tryParse(expiresIn.toString());

    final later = now.add(const Duration(milliseconds: 60000));
    // final later = now.add( Duration(milliseconds: convertExp ?? 0));
    AppUtils.logApp('FIRST DATE TIME NOW :::::::$now');
    AppUtils.logApp('FIRST GET TOKEN :::::::$later');

    await appStorage.write(CACHE_EXPIRES_TOKEN, later.toString());
  }
}
