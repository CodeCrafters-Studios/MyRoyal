import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/login/data/datasources/login_local_data.dart';
import 'package:iroyal/app/modules/login/data/datasources/login_remote.data.dart';
import 'package:iroyal/app/modules/login/data/models/cache_user_login.dart';
import 'package:iroyal/app/modules/login/domain/entities/cache_user_login.dart';
import 'package:iroyal/app/modules/login/domain/entities/login_params.dart';
import 'package:iroyal/app/modules/login/domain/entities/login_response.dart';
import 'package:iroyal/app/modules/login/domain/repositories/login_repository.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';

class LoginRepositoryImpl implements LoginRepository {
  LoginRepositoryImpl({required this.localData, required this.remoteData});

  final LoginLocalDataSource localData;
  final LoginRemoteDataSource remoteData;
  @override
  Future<Either<Failure, bool>> authBiometrics() async {
    try {
      final r = await localData.authBiometrics();
      if (r) {
        return const Right(true);
      } else {
        return const Left(BiometricsFailure());
      }
    } on BiometricsException {
      return const Left(BiometricsFailure());
    }
  }

  @override
  Future<Either<Failure, CacheUserLogin>> getCacheUserLogin() async {
    try {
      final r = await localData.getCacheUserLogin();
      return Right(r);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, LoginParams>> getLoginParam({
    required String grantType,
    required String username,
    required String password,
    required String clientId,
    required String clientSecret,
  }) async {
    try {
      final r = await localData.getLoginParams(
        grantType: grantType,
        username: username,
        password: password,
        clientId: clientId,
        clientSecret: clientSecret,
      );
      return Right(r);
    } on LocalDataException {
      return const Left(LocalDataFailure());
    }
  }

  @override
  Future<Either<Failure, LoginResponse>> loginApp(
    Map<String, dynamic> loginParams,
  ) async {
    try {
      final r = await remoteData.loginApp(loginParams);
      await localData.cacheLoginResponse(r);
      await localData.cacheUserLogin(
        CacheUserLoginModel(
          grantType: loginParams['grant_type'],
          username: loginParams['username'],
          password: loginParams['password'],
          clientId: loginParams['client_id'],
          clientSecret: loginParams['client_secret'],
        ),
      );
      await localData.saveLoginToken(
        r.accessToken,
        r.refreshToken,
        r.expiresin,
      );
      return Right(r);
    } catch (e) {
      return Left(ServerFailure(properties: [e]));
    }
  }
}
