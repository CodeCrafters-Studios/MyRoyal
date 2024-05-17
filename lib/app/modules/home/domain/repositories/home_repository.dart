import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/home/domain/entities/user.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class HomeRepository {
  Future<Either<Failure, User>> getUser();
}
