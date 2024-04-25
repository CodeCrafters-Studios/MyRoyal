import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/profile/data/datasources/local_data.dart';
import 'package:iroyal/app/modules/profile/domain/repositories/profile_repository.dart';
import 'package:iroyal/base/errors/failures.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required this.localData});

  final ProfileLocalData localData;
  @override
  Future<Either<Failure, bool>> logoutApp() async {
    try {
      final result = await localData.logout();
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(properties: [e]));
    }
  }
}
