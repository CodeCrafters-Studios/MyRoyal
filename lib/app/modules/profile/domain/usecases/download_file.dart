import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/profile/data/repositories/profile_repository_impl.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class DownloadFile implements UseCase<bool, String> {
  DownloadFile(this.repository);

  final ProfileRepositoryImpl repository;

  @override
  Future<Either<Failure, bool>> call(String url) {
    return repository.downloadFile(url);
  }
}
