import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/home/data/models/articles_model.dart';
import 'package:iroyal/app/modules/home/data/models/user_data.dart';
import 'package:iroyal/app/modules/home/domain/entities/user.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class HomeRepository {
  Future<Either<Failure, User>> getUser();
  Future<Either<Failure, UserDataModel>> getCacheUser();
  Future<Either<Failure, ArticlesModel>> getArticles();
}
