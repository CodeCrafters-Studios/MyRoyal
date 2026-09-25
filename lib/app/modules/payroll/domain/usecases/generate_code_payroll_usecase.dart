import 'package:MyRoyal/app/modules/payroll/data/models/generate_code_param_model.dart';
import 'package:MyRoyal/app/modules/payroll/domain/entities/generate_code_entity.dart';
import 'package:MyRoyal/app/modules/payroll/domain/repositories/payroll_period_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class GenerateCodePayrollUsecase
    implements UseCase<GenerateCodeEntity, GenerateCodeParamModel> {
  GenerateCodePayrollUsecase(this.repository);

  final PayrollPeriodRepository repository;

  @override
  Future<Either<Failure, GenerateCodeEntity>> call(params) {
    return repository.generateCode(params.toJson());
  }
}
