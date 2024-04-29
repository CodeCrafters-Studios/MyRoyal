import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/my_teams/domain/repositories/my_teams_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetMyTeams implements UseCaseNoParams {
  GetMyTeams(this.repository);

  final MyTeamsRepository repository;
  @override
  Future<Either<Failure, dynamic>> call() {
    return repository.getMyTeams();
  }
}
