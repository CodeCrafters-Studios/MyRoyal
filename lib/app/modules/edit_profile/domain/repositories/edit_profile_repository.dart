import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/edit_profile/data/model/employee_params_model.dart';
import 'package:MyRoyal/base/errors/failures.dart';

abstract class EditProfileRepository {
  Future<Either<Failure, bool>> patchEditProfile(
    EmployeeParamsModel editProfileParams,
  );
}
