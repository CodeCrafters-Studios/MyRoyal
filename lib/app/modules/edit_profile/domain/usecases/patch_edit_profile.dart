import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/edit_profile/data/model/employee_params_model.dart';
import 'package:iroyal/app/modules/edit_profile/data/repositories/edit_profile_repository_impl.dart';
import 'package:iroyal/app/modules/edit_profile/domain/entities/edit_profile_response.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class PatchEditProfile
    implements UseCase<EditProfileResponse, ParamsEditProfile> {
  PatchEditProfile(this.editProfileRepository);

  final EditProfileRepositoryImpl editProfileRepository;

  @override
  Future<Either<Failure, EditProfileResponse>> call(params) {
    return editProfileRepository.patchEditProfile(params.toMap());
  }
}

class ParamsEditProfile extends Equatable {
  const ParamsEditProfile({required this.employeeParams});

  final EmployeeParamsModel employeeParams;
  @override
  List<Object?> get props => [
        employeeParams,
      ];

  Map<String, dynamic> toMap() => employeeParams.toJson();
}
