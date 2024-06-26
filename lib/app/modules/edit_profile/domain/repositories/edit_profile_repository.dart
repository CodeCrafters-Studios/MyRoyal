import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/edit_profile/domain/entities/edit_profile.dart';
import 'package:iroyal/app/modules/edit_profile/domain/entities/edit_profile_response.dart';
import 'package:iroyal/app/modules/edit_profile/domain/entities/employee_params.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class EditProfileRepository {
  Future<Either<Failure, EditProfile>> patchEditProfile({
    required EmployeeParams employeeParams,
  });
  Future<Either<Failure, EditProfileResponse>> editProfileResponse(
    Map<String, dynamic> editProfileResponse,
  );
}
