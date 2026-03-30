import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:MyRoyal/app/modules/edit_profile/data/model/employee_params_model.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/services/http_service.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';

abstract class EditProfileRemoteDataSource {
  Future<bool> editProfile(EmployeeParamsModel editProfileParams);
}

class EditProfileRemoteSourceImpl implements EditProfileRemoteDataSource {
  EditProfileRemoteSourceImpl({
    required this.httpService,
  });

  final HttpService httpService;

  @override
  Future<bool> editProfile(EmployeeParamsModel editProfileParams) async {
    try {
      if (editProfileParams.profilePicture.isNotEmpty) {
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
        final r = await httpService.request(
          withToken: true,
          paramsImg: formData,
          endpoint: 'oauth/updateProfile',
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

        return true;
      } else {
        final r = await httpService.request(
          withToken: true,
          params: {
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
            "profile": editProfileParams.profilePicture,
          },
          endpoint: 'oauth/updateProfile',
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

        return true;
      }
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
