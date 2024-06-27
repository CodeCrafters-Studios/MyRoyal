import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/edit_profile/domain/entities/edit_profile_response.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class EditProfileRepository {
  Future<Either<Failure, EditProfileResponse>> patchEditProfile(
    Map<String, dynamic> editProfileParams,
    String id,
  );
}
