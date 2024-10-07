import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:iroyal/app/modules/edit_profile/data/model/employee_params_model.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/app_utils.dart';

abstract class EditProfileRemoteDataSource {
  Future<bool> editProfile(
    EmployeeParamsModel editProfileParams,
  );
}

class EditProfileRemoteSourceImpl implements EditProfileRemoteDataSource {
  EditProfileRemoteSourceImpl({required this.httpService});

  final HttpService httpService;

  @override
  Future<bool> editProfile(EmployeeParamsModel editProfileParams) async {
    try {
      var formData = FormData.fromMap({
        "employee_id": editProfileParams.employeeId,
        "first_name": editProfileParams.firstName,
        "last_name": editProfileParams.lastName,
        "nickname": editProfileParams.nickname,
        "personal_email": editProfileParams.email,
        "instagram": editProfileParams.instagram,
        "linkedin": editProfileParams.linkedIn,
        "marital_status": editProfileParams.maritalStatus,
        "birthplace": editProfileParams.birthPlace,
        "date_of_birth": editProfileParams.birthDate,
        "gender": editProfileParams.gender,
        "profile_picture": await MultipartFile.fromFile(
          editProfileParams.profilePicture,
          contentType: MediaType("image", "jpeg"),
        ),
      });

      AppUtils.logApp(
          'FORMDATA FILE ::: ${formData.files.first.value.filename}');
      for (var entry in formData.fields) {
        AppUtils.logApp('Field: ${entry.key} Value: ${entry.value}');
      }
      for (var file in formData.files) {
        AppUtils.logApp(
            'File Field: ${file.key} Filename: ${file.value.filename}');
      }
      final response = await httpService.request(
        withToken: true,
        paramsImg: formData,
        enpoint: 'oauth/updateProfile',
      );

      AppUtils.logApp("RESPONSE: ${response['data']}");

      return true;
    } catch (e) {
      AppUtils.logApp('Edit profile error: ${e.toString()}');
      throw ServerFailure(properties: [e]);
    }
  }
}
