import 'package:iroyal/app/modules/home/data/models/user.dart';
import 'package:iroyal/app/modules/home/domain/entities/user.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/services/http_service.dart';

abstract class HomeRemoteDataSource {
  Future<User> getUser();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl({required this.httpService});

  final HttpService httpService;
  @override
  Future<User> getUser() async {
    try {
      final r = await httpService.request(
        withToken: true,
        enpoint: '/api/v1/employees',
        method: Method.GET,
      );
      final userResponse = UserModel.fromJson(r);
      return userResponse;
    } on ApiException {
      rethrow;
    }
  }
}
