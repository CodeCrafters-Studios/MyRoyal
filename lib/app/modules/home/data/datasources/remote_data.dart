import 'package:iroyal/app/modules/home/data/models/user.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/services/http_service.dart';

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
        enpoint: '/auth/user',
        method: Method.GET,
      );
      final userResponse = UserModel.fromJson(r);
      return userResponse;
    } on ApiException {
      rethrow;
    }
  }
}
