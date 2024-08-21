import 'package:iroyal/app/modules/home/data/models/user.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/app_utils.dart';

abstract class HomeRemoteDataSource {
  Future<UserModel> getUser();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl({required this.httpService});

  final HttpService httpService;
  @override
  Future<UserModel> getUser() async {
    try {
      final r = await httpService.request(
        withToken: true,
        enpoint: 'oauth/user',
        method: Method.GET,
      );
      if (r['code'] != 200) {
        throw ApiException(r['message']);
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
      rethrow;
    }
  }
}
