import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/settings/domain/repositories/settings_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';

class BiometricsApp implements UseCaseNoParams<bool> {
  BiometricsApp(this.repository, this.appStorage);

  final SettingsRepository repository;
  final AppStorage appStorage;

  @override
  Future<Either<Failure, bool>> call() async {
    return repository.biometricsApp();
  }
}
