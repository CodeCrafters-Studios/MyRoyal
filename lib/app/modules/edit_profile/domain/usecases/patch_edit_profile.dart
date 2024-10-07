import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/edit_profile/data/model/employee_params_model.dart';
import 'package:iroyal/app/modules/edit_profile/data/repositories/edit_profile_repository_impl.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class PatchEditProfile implements UseCase<bool, EmployeeParamsModel> {
  PatchEditProfile(this.editProfileRepository);

  final EditProfileRepositoryImpl editProfileRepository;

  @override
  Future<Either<Failure, bool>> call(EmployeeParamsModel params) {
    return editProfileRepository.patchEditProfile(params);
  }
}
