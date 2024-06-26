import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/edit_profile/domain/entities/edit_profile.dart';
import 'package:iroyal/app/modules/edit_profile/domain/entities/edit_profile_response.dart';
import 'package:iroyal/app/modules/edit_profile/domain/entities/employee_params.dart';
import 'package:iroyal/app/modules/edit_profile/domain/repositories/edit_profile_repository.dart';
import 'package:iroyal/base/errors/failures.dart';

class EditProfileRepositoryImpl implements EditProfileRepository {
  final EditProfileLocalDataSource localData;
  final EditProfileRemoteDataSource remoteData;
  
  @override
  Future<Either<Failure, EditProfileResponse>> editProfileResponse(Map<String, dynamic> editProfileResponse) async {
   try {
     final r = await local
   } catch (e) {
     
   }
  }

  @override
  Future<Either<Failure, EditProfile>> patchEditProfile({required EmployeeParams employeeParams}) {
    // TODO: implement patchEditProfile
    throw UnimplementedError();
  }
  
}