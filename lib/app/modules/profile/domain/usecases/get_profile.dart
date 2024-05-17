import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/profile/domain/repositories/profile_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetProfile extends UseCase {
  GetProfile(this.repository);

  final ProfileRepository repository;

  @override
  Future<Either<Failure, dynamic>> call(params) {
    return repository.getProfile(params);
  }
}
