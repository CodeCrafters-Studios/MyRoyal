import 'dart:convert';

import 'package:MyRoyal/app/modules/home/data/models/user_model.dart';
import 'package:MyRoyal/app/modules/home/data/models/user_data_model.dart';
import 'package:MyRoyal/base/config/app_constants.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';
import 'package:MyRoyal/base/utils/storage/app_storage.dart';

abstract class HomeLocalData {
  Future<void> cacheUserResponse(UserModel userResponse);
  Future<UserDataModel> getCacheUser();
}

class HomeLocalDataSourceImpl implements HomeLocalData {
  HomeLocalDataSourceImpl({required this.appStorage});

  final AppStorage appStorage;
  @override
  Future<void> cacheUserResponse(UserModel userResponse) async {
    final jsonString = jsonEncode(userResponse.data.toJson());
    AppUtils.logApp('[INFO] CACHE USER :::: $jsonString');
    return appStorage.write(CACHE_USER, jsonString);
  }

  @override
  Future<UserDataModel> getCacheUser() async {
    final jsonString = await appStorage.read(CACHE_USER);
    if (jsonString != null) {
      return UserDataModel.fromJson(jsonDecode(jsonString));
    } else {
      throw CacheException('Data Not Found');
    }
  }
}
