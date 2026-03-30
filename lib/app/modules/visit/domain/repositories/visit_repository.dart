import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/visit/domain/entities/locations.dart';
import 'package:MyRoyal/base/errors/failures.dart';

abstract class VisitRepository {
  Future<Either<Failure, List<Locations>>> getLocations();
}
