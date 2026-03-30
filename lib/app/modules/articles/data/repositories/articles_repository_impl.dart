import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/articles/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/articles/data/models/articles_detail_model.dart';
import 'package:MyRoyal/app/modules/articles/data/models/books_detail_model.dart';
import 'package:MyRoyal/app/modules/articles/domain/repositories/articles_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';

class ArticlesRepositoryImpl implements ArticlesRepository {
  final ArticlesRemoteDataSources remoteData;

  ArticlesRepositoryImpl(this.remoteData);

  @override
  Future<Either<Failure, ArticlesDetailModel>> getArticlesDetail(
      String id) async {
    try {
      final r = await remoteData.getArticlesDetail(id);
      return Right(r);
    } catch (e) {
      return Left(ServerFailure(properties: [e]));
    }
  }

  @override
  Future<Either<Failure, BooksDetailModel>> getBooksDetail(String id) async {
    try {
      final r = await remoteData.getBooksDetail(id);
      return Right(r);
    } catch (e) {
      return Left(ServerFailure(properties: [e]));
    }
  }
}
