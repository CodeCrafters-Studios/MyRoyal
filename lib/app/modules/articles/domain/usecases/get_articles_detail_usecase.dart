import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/articles/data/models/articles_detail_model.dart';
import 'package:iroyal/app/modules/articles/domain/repositories/articles_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetArticlesDetailUsecase implements UseCase<ArticlesDetailModel, String> {
  GetArticlesDetailUsecase(this.repository);

  final ArticlesRepository repository;

  @override
  Future<Either<Failure, ArticlesDetailModel>> call(String params) {
    return repository.getArticlesDetail(params);
  }
}
