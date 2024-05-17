import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/webtel/domain/entities/webtel.dart';
import 'package:iroyal/app/modules/webtel/domain/repositories/webtel_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetWebtel implements UseCaseNoParams<List<Webtel>> {
  GetWebtel(this.repository);

  final WebtelRepository repository;

  @override
  Future<Either<Failure, List<Webtel>>> call() {
    return repository.getWebtel();
  }
}
