import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/edit_profile/data/datasources/edit_profile_remote.dart';
import 'package:iroyal/app/modules/edit_profile/domain/entities/edit_profile_response.dart';
import 'package:iroyal/app/modules/edit_profile/domain/repositories/edit_profile_repository.dart';
import 'package:iroyal/base/errors/failures.dart';

class EditProfileRepositoryImpl implements EditProfileRepository {
  EditProfileRepositoryImpl({required this.remoteData});

  final EditProfileRemoteSourceImpl remoteData;

  @override
  Future<Either<Failure, EditProfileResponse>> patchEditProfile(
      Map<String, dynamic> editProfileParams) async {
    try {
      final r = await remoteData.editProfile(editProfileParams);
      return Right(r);
    } catch (e) {
      return Left(ServerFailure(properties: [e]));
    }
  }
}
