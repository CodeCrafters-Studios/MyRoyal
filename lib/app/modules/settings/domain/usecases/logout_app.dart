import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/settings/domain/repositories/settings_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class LogoutApp implements UseCaseNoParams<bool> {
  LogoutApp(this.repository);

  final SettingsRepository repository;

  @override
  Future<Either<Failure, bool>> call() {
    return repository.logoutApp();
  }
}
