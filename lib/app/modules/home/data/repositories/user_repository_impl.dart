import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/home/data/datasources/local_data.dart';
import 'package:iroyal/app/modules/home/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/home/domain/entities/user.dart';
import 'package:iroyal/app/modules/home/domain/repositories/home_repository.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({required this.localData, required this.remoteData});

  final HomeLocalData localData;
  final HomeRemoteDataSource remoteData;

  @override
  Future<Either<Failure, User>> getUser() async {
    try {
      final r = await remoteData.getUser();
      await localData.cacheUserResponse(r);
      return Right(r);
    } on ApiException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getCacheUser() async {
    try {
      final r = await localData.getCacheUserLogin();
      return Right(r);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }
}
