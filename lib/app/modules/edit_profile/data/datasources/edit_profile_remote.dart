import 'package:iroyal/app/modules/edit_profile/data/model/edit_profile_response_model.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/services/http_service.dart';

abstract class EditProfileRemoteDataSource {
  Future<EditProfileResponseModel> editProfile(
    Map<String, dynamic> editProfileParams,
    String id,
  );
}

class EditProfileRemoteSourceImpl implements EditProfileRemoteDataSource {
  EditProfileRemoteSourceImpl({required this.httpService});

  final HttpService httpService;

  @override
  Future<EditProfileResponseModel> editProfile(
    Map<String, dynamic> editProfileParams,
    String id,
  ) async {
    try {
      final r = await httpService.request(
        withToken: true,
        params: editProfileParams,
        enpoint: '/api/v1/employees/$id/update_profile',
        method: Method.PATCH,
      );
      final editProfileResponse = EditProfileResponseModel.fromJson(r);
      return editProfileResponse;
    } on ApiException {
      rethrow;
    }
  }
}
