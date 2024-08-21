import 'dart:convert';

import 'package:iroyal/app/modules/home/data/models/user.dart';
import 'package:iroyal/app/modules/home/data/models/user_data.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';

abstract class HomeLocalData {
  Future<void> cacheUserResponse(UserModel userResponse);
  Future<UserDataModel> getCacheUserLogin();
}

class HomeLocalDataSourceImpl implements HomeLocalData {
  HomeLocalDataSourceImpl({required this.appStorage});

  final AppStorage appStorage;
  @override
  Future<void> cacheUserResponse(UserModel userResponse) async {
    final jsonString = jsonEncode(userResponse.data.toJson());
    AppUtils.logApp('CACHE USER :::: $jsonString');
    return appStorage.write(CACHE_USER, jsonString);
  }

  @override
  Future<UserDataModel> getCacheUserLogin() async {
    final jsonString = await appStorage.read(CACHE_USER);
    if (jsonString != null) {
      return UserDataModel.fromJson(jsonDecode(jsonString));
    } else {
      throw CacheException('Data Not Found');
    }
  }
}
