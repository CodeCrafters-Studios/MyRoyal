import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/webtel/domain/entities/webtel.dart';
import 'package:MyRoyal/app/modules/webtel/domain/repositories/webtel_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class GetWebtel implements UseCaseNoParams<Webtel> {
  GetWebtel(this.repository);

  final WebtelRepository repository;

  @override
  Future<Either<Failure, Webtel>> call() {
    return repository.getWebtel();
  }
}
