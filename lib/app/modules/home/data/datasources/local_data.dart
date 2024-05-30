import 'dart:convert';

import 'package:iroyal/app/modules/home/data/models/user.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';

abstract class HomeLocalData {
  Future<void> cacheUserResponse(UserModel user);
  Future<UserModel> getCacheUserResponse();
}

class HomeLocalDataSourceImpl implements HomeLocalData {
  HomeLocalDataSourceImpl({required this.appStorage});

  final AppStorage appStorage;
  @override
  Future<void> cacheUserResponse(UserModel user) async {
    try {
      final jsonString = jsonEncode(user.toJson());
      await appStorage.write(CACHE_USER, jsonString);
    } catch (e) {
      throw CacheException('');
    }
  }

  @override
  Future<UserModel> getCacheUserResponse() async {
    try {
      final jsonString = await appStorage.read(CACHE_USER);
      if (jsonString != null) {
        return UserModel.fromJson(jsonDecode(jsonString));
      } else {
        throw CacheException('Data Not Found');
      }
    } catch (e) {
      throw CacheException('');
    }
  }
}
