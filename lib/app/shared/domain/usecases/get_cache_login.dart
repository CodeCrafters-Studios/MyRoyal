import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/login/domain/entities/login_response.dart';
import 'package:iroyal/app/shared/domain/repositories/global_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetCacheLogin implements UseCaseNoParams<LoginResponse> {
  GetCacheLogin(this.repository);

  final GlobalRepository repository;
  @override
  Future<Either<Failure, LoginResponse>> call() {
    return repository.getCaheLogin();
  }
}
