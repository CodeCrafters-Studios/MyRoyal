import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/login/domain/entities/login_response.dart';
import 'package:iroyal/app/shared/data/datasources/local_data.dart';
import 'package:iroyal/app/shared/data/datasources/remote_data.dart';
import 'package:iroyal/app/shared/domain/repositories/global_repository.dart';
import 'package:iroyal/base/errors/failures.dart';

class GlobalRepositoryImpl implements GlobalRepository {
  GlobalRepositoryImpl({required this.localData, required this.remoteData});

  final GlobalLocalData localData;
  final GlobalRemoteData remoteData;

  @override
  Future<Either<Failure, LoginResponse>> getCaheLogin() async {
    try {
      final r = await localData.getCacheLogin();
      return Right(r);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }
}
