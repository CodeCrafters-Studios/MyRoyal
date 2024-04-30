import 'package:dartz/dartz.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class ProfileRepository {
  Future<Either<Failure, bool>> logoutApp();
  Future<Either<Failure, bool>> biometricsApp();
}
