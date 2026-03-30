import 'dart:convert';

import 'package:MyRoyal/app/modules/login/data/models/login_response.dart';
import 'package:MyRoyal/base/config/app_constants.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/utils/storage/app_storage.dart';

abstract class GlobalLocalData {
  Future<LoginResponseModel> getCacheLogin();
}

class GlobalLocalDataImpl implements GlobalLocalData {
  GlobalLocalDataImpl({required this.appStorage});

  final AppStorage appStorage;
  @override
  Future<LoginResponseModel> getCacheLogin() async {
    final jsonString = await appStorage.read(CACHE_LOGIN_RESPONSE);
    if (jsonString != null) {
      return LoginResponseModel.fromJson(jsonDecode(jsonString));
    } else {
      throw CacheException('Data Not Found');
    }
  }
}
