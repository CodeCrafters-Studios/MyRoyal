import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/login/domain/entities/cache_user_login.dart';
import 'package:iroyal/app/modules/login/domain/entities/login_params.dart';
import 'package:iroyal/app/modules/login/domain/entities/login_response.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class LoginRepository {
  Future<Either<Failure, LoginParams>> getLoginParam({
    required String grantType,
    required String clientId,
    required String clientSecret,
    required String username,
    required String password,
    required String scope,
    required String fcmToken,
  });
  Future<Either<Failure, LoginResponse>> loginApp(
    Map<String, dynamic> loginParams,
  );
  Future<Either<Failure, CacheUserLogin>> getCacheUserLogin();
  Future<Either<Failure, bool>> authBiometrics();
}
