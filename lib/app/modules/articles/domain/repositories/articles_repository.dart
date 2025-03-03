import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/articles/data/models/articles_detail_model.dart';
import 'package:iroyal/app/modules/articles/data/models/books_detail_model.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class ArticlesRepository {
  Future<Either<Failure, ArticlesDetailModel>> getArticlesDetail(String id);
  Future<Either<Failure, BooksDetailModel>> getBooksDetail(String id);
}
