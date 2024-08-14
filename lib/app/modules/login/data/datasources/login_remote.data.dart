import 'package:iroyal/app/modules/login/data/models/login_response.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/services/http_service.dart';

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
        enpoint: '/login',
      );
      final loginResponse = LoginResponseModel.fromJson(r);
      return loginResponse;
    } on ApiException {
      rethrow;
    }
  }
}
