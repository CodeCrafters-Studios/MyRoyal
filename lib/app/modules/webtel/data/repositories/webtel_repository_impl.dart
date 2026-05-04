import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/webtel/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/webtel/domain/entities/webtel_entity.dart';
import 'package:MyRoyal/app/modules/webtel/domain/repositories/webtel_repository.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/errors/failures.dart';

class WebtelRepositoryImpl implements WebtelRepository {
  WebtelRepositoryImpl({required this.remoteData});

  final WebtelRemoteDataSources remoteData;

  @override
  Future<Either<Failure, WebtelEntity>> getWebtel() async {
    try {
      final r = await remoteData.getWebtel();
      return Right(r);
    } on ApiException {
      return const Left(ServerFailure());
    }
  }
}
