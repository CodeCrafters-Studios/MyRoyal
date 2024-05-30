import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:iroyal/app/modules/login/data/models/login_response.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';

abstract class GlobalLocalData {
  Future<LoginResponseModel> getCacheLogin();
  Future<void> cacheRefreshToken(String token);
  Future<Locale> getLanguage();
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

  @override
  Future<void> cacheRefreshToken(String token) async {
    try {
      await appStorage.write(CACHE_REFRESH_TOKEN, token);
    } catch (e) {
      throw CacheException(e.toString());
    }
  }

  @override
  Future<Locale> getLanguage() async {
    final lang = await appStorage.read(CACHE_LANGUAGE);
    if (lang == 'id' || lang == null) {
      return const Locale('id', 'ID');
    } else {
      return const Locale('en', 'US');
    }
  }
}
