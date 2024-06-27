import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/edit_profile/domain/entities/edit_profile_response.dart';
import 'package:iroyal/app/modules/edit_profile/domain/entities/employee_params.dart';
import 'package:iroyal/app/modules/edit_profile/domain/repositories/edit_profile_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class PatchEditProfile
    implements UseCase<EditProfileResponse, ParamsEditProfile> {
  PatchEditProfile(this.editProfileRepository);

  final EditProfileRepository editProfileRepository;

  @override
  Future<Either<Failure, EditProfileResponse>> call(ParamsEditProfile params) {
    return editProfileRepository.patchEditProfile(params.toMap(), params.id);
  }
}

class ParamsEditProfile extends Equatable {
  const ParamsEditProfile({required this.employeeParams, required this.id});

  final EmployeeParams employeeParams;
  final String id;

  @override
  List<Object?> get props => [
        employeeParams,
        id,
      ];

  Map<String, dynamic> toMap() => {
        "employee": employeeParams.toJson(),
      };
}
