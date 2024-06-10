import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/visit/domain/entities/locations.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class VisitRepository {
  Future<Either<Failure, List<Locations>>> getLocations();
}
