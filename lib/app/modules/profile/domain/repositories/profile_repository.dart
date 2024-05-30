import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/profile/domain/entities/profile.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile(String id);
  Future<Either<Failure, bool>> downloadFile(String url);
}
