import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/my_teams/domain/entities/my_teams.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class MyTeamsRepository {
  Future<Either<Failure, MyTeams>> getMyTeams();
}
