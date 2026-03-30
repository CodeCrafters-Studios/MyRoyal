import 'package:MyRoyal/app/modules/profile/data/models/profile_model.dart';
import 'package:MyRoyal/app/modules/profile/domain/entities/profile.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/services/http_service.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';

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
        endpoint: 'oauth/profile',
        method: Method.GET,
        showPopUp: true,
      );
      if (r == null) {
        throw ApiException('No response from server');
      }

      final code = r['code'];
      final message = r['message'] ?? 'Unknown error occurred';

      if (code != 200) {
        throw ApiException(message);
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
