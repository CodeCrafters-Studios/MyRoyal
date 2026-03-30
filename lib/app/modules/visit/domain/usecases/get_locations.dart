import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/visit/domain/entities/locations.dart';
import 'package:MyRoyal/app/modules/visit/domain/repositories/visit_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class GetLocations extends UseCaseNoParams {
  GetLocations(this.repository);

  final VisitRepository repository;

  @override
  Future<Either<Failure, List<Locations>>> call() {
    return repository.getLocations();
  }
}
