import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/my_teams/domain/entities/my_teams.dart';
import 'package:MyRoyal/base/errors/failures.dart';

abstract class MyTeamsRepository {
  Future<Either<Failure, MyTeams>> getMyTeams(String id);
}
