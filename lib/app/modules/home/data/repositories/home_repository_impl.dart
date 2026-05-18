import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/home/data/models/banner_event_model.dart';
import 'package:MyRoyal/app/modules/home/data/models/user_model.dart';
import 'package:MyRoyal/app/modules/home/data/models/user_jde_model.dart';
import 'package:MyRoyal/app/modules/home/data/datasources/local_data.dart';
import 'package:MyRoyal/app/modules/home/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/home/data/models/articles_model.dart';
import 'package:MyRoyal/app/modules/home/data/models/user_data_model.dart';
import 'package:MyRoyal/app/modules/home/domain/repositories/home_repository.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/errors/failures.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({required this.localData, required this.remoteData});

  final HomeLocalData localData;
  final HomeRemoteDataSource remoteData;

  @override
  Future<Either<Failure, UserModel>> getUser() async {
    try {
      final r = await remoteData.getUser();
      await localData.cacheUserResponse(r);
      return Right(r);
    } catch (e) {
      return Left(ServerFailure(properties: [e]));
    }
  }

  @override
  Future<Either<Failure, UserDataModel>> getCacheUser() async {
    try {
      final r = await localData.getCacheUser();
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

  @override
  Future<Either<Failure, List<BannerEventModel>>> getBannerEvent() async {
    try {
      final r = await remoteData.getBannerEvent();
      return Right(r);
    } catch (e) {
      return Left(ServerFailure(properties: [e]));
    }
  }
}
