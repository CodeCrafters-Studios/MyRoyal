import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/my_teams/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/my_teams/domain/entities/my_teams.dart';
import 'package:iroyal/app/modules/my_teams/domain/repositories/my_teams_repository.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';

class MyTeamsRepositoryImpl extends MyTeamsRepository {
  MyTeamsRepositoryImpl({required this.remoteData});

  final MyTeamsRemoteDataSources remoteData;
  @override
  Future<Either<Failure, MyTeams>> getMyTeams() async {
    try {
      final r = await remoteData.getMyTeams();
      return Right(r);
    } on ApiException {
      return const Left(ServerFailure());
    }
  }
}
