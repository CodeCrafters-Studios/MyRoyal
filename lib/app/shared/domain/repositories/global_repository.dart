import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/login/domain/entities/login_response.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class GlobalRepository {
  Future<Either<Failure, LoginResponse>> getCaheLogin();
}
