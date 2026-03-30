import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/login/domain/entities/login_response.dart';
import 'package:MyRoyal/base/errors/failures.dart';

abstract class GlobalRepository {
  Future<Either<Failure, LoginResponse>> getCaheLogin();
}
