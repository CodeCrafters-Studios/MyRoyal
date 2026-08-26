import 'package:MyRoyal/app/modules/ocr/domain/entities/data_master_employee_os_entity.dart';
import 'package:MyRoyal/app/modules/ocr/domain/repositories/ocr_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class GetDataMasterEmployeeOsUsecase
    implements UseCaseNoParams<DataMasterEmployeeOsEntity> {
  GetDataMasterEmployeeOsUsecase({required this.repository});

  final OcrRepository repository;

  @override
  Future<Either<Failure, DataMasterEmployeeOsEntity>> call() {
    return repository.getDataMasterEmployeeOs();
  }
}
