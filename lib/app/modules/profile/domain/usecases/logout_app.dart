import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/profile/domain/repositories/profile_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class LogoutApp implements UseCaseNoParams<bool> {
  LogoutApp(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, bool>> call() {
    return repository.logoutApp();
  }
}
