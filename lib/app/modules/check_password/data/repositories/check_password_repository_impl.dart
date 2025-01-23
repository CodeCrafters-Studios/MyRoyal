import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/check_password/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/check_password/data/models/check_password_model.dart';
import 'package:iroyal/app/modules/check_password/domain/repositories/check_password_repository.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';

class CheckPasswordRepositoryImpl implements CheckPasswordRepository {
  CheckPasswordRepositoryImpl(this.remoteDataSource);

  final CheckPasswordRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, CheckPasswordModel>> checkPassword(
      Map<String, dynamic> params) async {
    try {
      final r = await remoteDataSource.checkPassword(params);
      return Right(r);
    } on ApiException {
      return const Left(ServerFailure());
    }
  }
}
