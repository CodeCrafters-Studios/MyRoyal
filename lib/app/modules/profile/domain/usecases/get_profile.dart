import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/profile/domain/repositories/profile_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class GetProfile extends UseCaseNoParams {
  GetProfile(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, dynamic>> call() {
    return repository.getProfile();
  }
}
