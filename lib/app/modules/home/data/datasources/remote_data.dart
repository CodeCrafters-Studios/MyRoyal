import 'package:MyRoyal/app/modules/home/data/models/banner_event_model.dart';
import 'package:MyRoyal/app/modules/home/data/models/user_jde_model.dart';
import 'package:MyRoyal/app/modules/home/data/models/articles_model.dart';
import 'package:MyRoyal/app/modules/home/data/models/user_model.dart';
import 'dart:io';
import 'package:flutter/services.dart';

import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/services/http_service.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';

abstract class HomeRemoteDataSource {
  Future<UserModel> getUser();
  Future<ArticlesModel> getArticles();
  Future<UserJdeModel> getUserJde(params);
  Future<List<BannerEventModel>> getBannerEvent();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl({required this.httpService});

  final HttpService httpService;
  @override
  Future<UserModel> getUser() async {
    try {
      final r = await httpService.request(
        withToken: true,
        endpoint: 'oauth/user',
        method: Method.GET,
      );
      if (r['code'] != 200) throw ApiException(r['message']);

      if (r['data'] != null && r['data']['banned'] == true) {
        AppDialogImpl().showErrorDialog(
          title: "User telah dibanned",
          description:
              "Akun Anda telah dinonaktifkan. Silakan hubungi administrator.",
          textButton: "Tutup Aplikasi",
          onPress: () async {
            if (Platform.isAndroid) {
              SystemNavigator.pop();
            } else {
              exit(0);
            }
          },
        );
        // Delay forever so the app doesn't proceed to parse or load
        await Future.delayed(const Duration(days: 999));
      }

      final userResponse = UserModel.fromJson(r);
      return userResponse;
    } on ServerFailure {
      throw ApiException('Server error occurred');
    } on ApiException catch (e) {
      AppUtils.logApp('CATCH ERR ::: ${e.message}');
      throw ApiException(e.message ?? 'An error occurred');
    } catch (e, stackTrace) {
      AppUtils.logApp('Error parsing JSON: $e\n$stackTrace');
      if (e is ApiException) rethrow;
      throw ApiException(e.toString());
    }
  }

  @override
  Future<ArticlesModel> getArticles() async {
    try {
      final r = await httpService.request(
        withToken: true,
        endpoint: 'api/shelves',
        method: Method.GET,
      );
      if (r == null) {
        throw ApiException('No response from server');
      }

      final code = r['code'];
      final message = r['message'] ?? 'Unknown error occurred';

      if (code != 200) {
        throw ApiException(message);
      }

      final articlesResponse = ArticlesModel.fromJson(r);
      return articlesResponse;
    } catch (e) {
      throw ApiException('$e');
    }
  }

  @override
  Future<UserJdeModel> getUserJde(params) async {
    try {
      final r = await httpService.request(
        withToken: true,
        endpoint: 'trackproduct/getUserJde',
        params: params,
      );

      if (r == null) {
        throw ApiException('No response from server');
      }

      final code = r['code'];
      final message = r['message'] ?? 'Unknown error occurred';

      if (code != 200) {
        throw ApiException(message);
      }

      return UserJdeModel.fromJson(r);
    } on ServerFailure {
      throw ApiException('Server error occurred');
    } on ApiException catch (e) {
      AppUtils.logApp('CATCH ERR ::: ${e.message}');
      throw ApiException(e.message ?? 'An error occurred');
    } catch (e, stackTrace) {
      AppUtils.logApp('Error parsing JSON: $e\n$stackTrace');
      throw ApiException(e.toString());
    }
  }

  @override
  Future<List<BannerEventModel>> getBannerEvent() async {
    try {
      final r = await httpService.request(
        withToken: true,
        endpoint: 'dashboard/banner',
        method: Method.GET,
      );

      if (r == null) {
        throw ApiException('No response from server');
      }

      if (r['code'] != 200) {
        throw ApiException(r['message'] ?? 'Unknown error');
      }

      final data = r['data'];
      if (data == null || data is! List) {
        AppUtils.logApp(
            'Banner event response data invalid: ${data.runtimeType}');
        return <BannerEventModel>[];
      }

      final List<BannerEventModel> response =
          data.map((x) => BannerEventModel.fromJson(x)).toList();

      return response;
    } on ServerFailure {
      throw ApiException('Server error occurred');
    } on ApiException catch (e) {
      AppUtils.logApp('CATCH ERR ::: ${e.message}');
      throw ApiException(e.message ?? 'An error occurred');
    } catch (e, stackTrace) {
      AppUtils.logApp('Error parsing JSON: $e\n$stackTrace');
      throw ApiException(e.toString());
    }
  }
}
