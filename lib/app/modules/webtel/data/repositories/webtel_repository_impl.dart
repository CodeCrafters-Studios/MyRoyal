import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/webtel/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/webtel/domain/entities/webtel.dart';
import 'package:iroyal/app/modules/webtel/domain/repositories/webtel_repository.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';

class WebtelRepositoryImpl implements WebtelRepository {
  WebtelRepositoryImpl({required this.remoteData});

  final WebtelRemoteDataSources remoteData;

  @override
  Future<Either<Failure, List<Webtel>>> getWebtel() async {
    try {
      final r = await remoteData.getWebtel();
      return Right(r);
    } on ApiException {
      return const Left(ServerFailure());
    }
  }
}
