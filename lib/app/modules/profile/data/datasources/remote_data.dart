import 'package:iroyal/app/modules/profile/data/models/profile_model.dart';
import 'package:iroyal/app/modules/profile/domain/entities/profile.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/app_utils.dart';

abstract class ProfileRemoteDataSources {
  Future<Profile> getProfile();
}

class ProfileRemoteDataSourcesImpl extends ProfileRemoteDataSources {
  ProfileRemoteDataSourcesImpl({required this.httpService});

  final HttpService httpService;
  @override
  Future<Profile> getProfile() async {
    try {
      final r = await httpService.request(
        withToken: true,
        enpoint: 'oauth/profile',
        method: Method.GET,
      );
      if (r['code'] != 200) {
        throw ApiException(r['message']);
      }
      final profileResponse = ProfileModel.fromJson(r);
      return profileResponse;
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
