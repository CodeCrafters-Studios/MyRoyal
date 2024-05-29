import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/profile/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/profile/domain/entities/profile.dart';
import 'package:iroyal/app/modules/profile/domain/repositories/profile_repository.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  ProfileRepositoryImpl({required this.remoteData});

  final ProfileRemoteDataSources remoteData;

  @override
  Future<Either<Failure, Profile>> getProfile(String id) async {
    try {
      final r = await remoteData.getProfile(id);
      return Right(r);
    } on ApiException {
      return const Left(ServerFailure());
    }
  }
}
