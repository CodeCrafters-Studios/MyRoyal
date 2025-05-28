import 'package:iroyal/app/modules/login/data/models/login_response.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/app_utils.dart';

abstract class LoginRemoteDataSource {
  Future<LoginResponseModel> loginApp(Map<String, dynamic> loginParams);
}

class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  LoginRemoteDataSourceImpl({required this.httpService});

  final HttpService httpService;
  @override
  Future<LoginResponseModel> loginApp(Map<String, dynamic> loginParams) async {
    try {
      final r = await httpService.request(
        params: loginParams,
        endpoint: 'oauth/token',
      );
      if (r['code'] != 200) {
        throw ApiException(r['message']);
      }
      final loginResponse = LoginResponseModel.fromJson(r);
      return loginResponse;
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
