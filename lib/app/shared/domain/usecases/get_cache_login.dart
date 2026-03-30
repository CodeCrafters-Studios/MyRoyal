import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/login/domain/entities/login_response.dart';
import 'package:MyRoyal/app/shared/domain/repositories/global_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class GetCacheLogin implements UseCaseNoParams<LoginResponse> {
  GetCacheLogin(this.repository);

  final GlobalRepository repository;
  @override
  Future<Either<Failure, LoginResponse>> call() {
    return repository.getCaheLogin();
  }
}
