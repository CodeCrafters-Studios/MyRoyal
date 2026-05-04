import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/webtel/domain/entities/webtel_entity.dart';
import 'package:MyRoyal/app/modules/webtel/domain/repositories/webtel_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class GetWebtel implements UseCaseNoParams<WebtelEntity> {
  GetWebtel(this.repository);

  final WebtelRepository repository;

  @override
  Future<Either<Failure, WebtelEntity>> call() {
    return repository.getWebtel();
  }
}
