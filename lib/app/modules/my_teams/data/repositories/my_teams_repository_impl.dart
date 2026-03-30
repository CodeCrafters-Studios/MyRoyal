import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/my_teams/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/my_teams/domain/entities/my_teams.dart';
import 'package:MyRoyal/app/modules/my_teams/domain/repositories/my_teams_repository.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/errors/failures.dart';

class MyTeamsRepositoryImpl extends MyTeamsRepository {
  MyTeamsRepositoryImpl({required this.remoteData});

  final MyTeamsRemoteDataSources remoteData;

  @override
  Future<Either<Failure, MyTeams>> getMyTeams(String id) async {
    try {
      final r = await remoteData.getMyTeams(id);
      return Right(r);
    } on ApiException {
      return const Left(ServerFailure());
    }
  }
}
