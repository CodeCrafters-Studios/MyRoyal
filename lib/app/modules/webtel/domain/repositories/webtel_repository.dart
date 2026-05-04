import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/webtel/domain/entities/webtel_entity.dart';
import 'package:MyRoyal/base/errors/failures.dart';

abstract class WebtelRepository {
  Future<Either<Failure, WebtelEntity>> getWebtel();
}
