import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/home/data/models/user_jde_model.dart';
import 'package:iroyal/app/modules/home/data/datasources/local_data.dart';
import 'package:iroyal/app/modules/home/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/home/data/models/articles_model.dart';
import 'package:iroyal/app/modules/home/data/models/user_data.dart';
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
  Future<Either<Failure, UserDataModel>> getCacheUser() async {
    try {
      final r = await localData.getCacheUserLogin();
      return Right(r);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, ArticlesModel>> getArticles() async {
    try {
      final r = await remoteData.getArticles();
      return Right(r);
    } catch (e) {
      return Left(ServerFailure(properties: [e]));
    }
  }

  @override
  Future<Either<Failure, UserJdeModel>> getUserJDE(params) async {
    try {
      final r = await remoteData.getUserJde(params);
      return Right(r);
    } catch (e) {
      return Left(ServerFailure(properties: [e]));
    }
  }
}
