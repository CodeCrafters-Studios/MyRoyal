import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/profile/data/datasources/local_data.dart';
import 'package:iroyal/app/modules/profile/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/profile/domain/entities/profile.dart';
import 'package:iroyal/app/modules/profile/domain/repositories/profile_repository.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  ProfileRepositoryImpl({
    required this.localData,
    required this.remoteData,
  });

  final ProfileLocalDataSources localData;
  final ProfileRemoteDataSources remoteData;

  @override
  Future<Either<Failure, Profile>> getProfile() async {
    try {
      final r = await remoteData.getProfile();
      return Right(r);
    } on ApiException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> downloadFile(String url) async {
    try {
      final r = await localData.downloadFile(url);
      return Right(r);
    } catch (e) {
      return const Left(LocalDataFailure());
    }
  }
}
