import 'package:iroyal/app/modules/profile/data/models/profile_model.dart';
import 'package:iroyal/app/modules/profile/domain/entities/profile.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/services/http_service.dart';

abstract class ProfileRemoteDataSources {
  Future<Profile> getProfile(String id);
}

class ProfileRemoteDataSourcesImpl extends ProfileRemoteDataSources {
  ProfileRemoteDataSourcesImpl({required this.httpService});

  final HttpService httpService;
  @override
  Future<Profile> getProfile(String id) async {
    try {
      final r = await httpService.request(
        withToken: true,
        enpoint: '/api/v1/employees/$id/profile',
        method: Method.GET,
      );
      final profileResponse = ProfileModel.fromJson(r);
      return profileResponse;
    } on ApiException {
      rethrow;
    }
  }
}
