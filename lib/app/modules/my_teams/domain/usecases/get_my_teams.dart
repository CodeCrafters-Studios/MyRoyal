import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/my_teams/domain/repositories/my_teams_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class GetMyTeams implements UseCase {
  GetMyTeams(this.repository);

  final MyTeamsRepository repository;
  @override
  Future<Either<Failure, dynamic>> call(params) {
    return repository.getMyTeams(params);
  }
}
