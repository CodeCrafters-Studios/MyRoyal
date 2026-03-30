import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/settings/data/datasources/local_data.dart';
import 'package:MyRoyal/app/modules/settings/domain/repositories/settings_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({required this.localData});

  final SettingsLocalData localData;
  @override
  Future<Either<Failure, bool>> logoutApp() async {
    try {
      final result = await localData.logout();
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(properties: [e]));
    }
  }

  @override
  Future<Either<Failure, bool>> biometricsApp() async {
    try {
      final result = await localData.biometrics();
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(properties: [e]));
    }
  }
}
