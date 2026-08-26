import 'package:MyRoyal/app/modules/ocr/domain/repositories/ocr_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class GetEmployeeOsUsecase implements UseCase {
  GetEmployeeOsUsecase(this.repository);

  final OcrRepository repository;

  @override
  Future<Either<Failure, dynamic>> call(params) {
    return repository.getEmployeeOs(params);
  }
}
