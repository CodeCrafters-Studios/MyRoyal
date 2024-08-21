import 'package:iroyal/app/modules/edit_profile/data/model/edit_profile_response_model.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/app_utils.dart';

abstract class EditProfileRemoteDataSource {
  Future<EditProfileResponseModel> editProfile(
      Map<String, dynamic> editProfileParams);
}

class EditProfileRemoteSourceImpl implements EditProfileRemoteDataSource {
  EditProfileRemoteSourceImpl({required this.httpService});

  final HttpService httpService;

  @override
  Future<EditProfileResponseModel> editProfile(
      Map<String, dynamic> editProfileParams) async {
    try {
      final r = await httpService.request(
        withToken: true,
        params: editProfileParams,
        enpoint: 'oauth/updateProfile',
      );
      if (r['code'] != 200) {
        throw ApiException(r['message']);
      }
      final editProfileResponse = EditProfileResponseModel.fromJson(r);
      return editProfileResponse;
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
