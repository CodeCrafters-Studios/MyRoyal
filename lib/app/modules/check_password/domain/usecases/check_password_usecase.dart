import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/check_password/data/models/check_password_model.dart';
import 'package:iroyal/app/modules/check_password/domain/repositories/check_password_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class CheckPasswordUsecase
    extends UseCase<CheckPasswordModel, CheckPasswordParams> {
  final CheckPasswordRepository repository;

  CheckPasswordUsecase(this.repository);

  @override
  Future<Either<Failure, CheckPasswordModel>> call(CheckPasswordParams params) {
    return repository.checkPassword(params.toJson());
  }
}
