import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/check_password/data/models/check_password_model.dart';
import 'package:MyRoyal/base/errors/failures.dart';

abstract class CheckPasswordRepository {
  Future<Either<Failure, CheckPasswordModel>> checkPassword(
    Map<String, dynamic> params,
  );
}
