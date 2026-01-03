import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/home/data/models/banner_event_model.dart';
import 'package:iroyal/app/modules/home/data/models/user_model.dart';
import 'package:iroyal/app/modules/home/data/models/user_jde_model.dart';
import 'package:iroyal/app/modules/home/data/models/articles_model.dart';
import 'package:iroyal/app/modules/home/data/models/user_data_model.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class HomeRepository {
  Future<Either<Failure, UserModel>> getUser();
  Future<Either<Failure, UserDataModel>> getCacheUser();
  Future<Either<Failure, ArticlesModel>> getArticles();
  Future<Either<Failure, UserJdeModel>> getUserJDE(params);
  Future<Either<Failure, BannerEventModel>> getBannerEvent();
}
