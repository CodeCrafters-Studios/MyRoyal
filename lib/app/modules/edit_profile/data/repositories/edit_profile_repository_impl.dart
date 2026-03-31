import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/edit_profile/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/edit_profile/data/model/employee_params_model.dart';
import 'package:MyRoyal/app/modules/edit_profile/domain/repositories/edit_profile_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';

class EditProfileRepositoryImpl implements EditProfileRepository {
  EditProfileRepositoryImpl({required this.remoteData});

  final EditProfileRemoteSourceImpl remoteData;

  @override
  Future<Either<Failure, bool>> patchEditProfile(
      EmployeeParamsModel editProfileParams) async {
    try {
      final r = await remoteData.editProfile(editProfileParams);
      return Right(r);
    } catch (e) {
      return Left(ServerFailure(properties: [e]));
    }
  }
}
