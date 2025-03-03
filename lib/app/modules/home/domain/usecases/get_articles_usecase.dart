import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/home/data/models/articles_model.dart';
import 'package:iroyal/app/modules/home/domain/repositories/home_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetArticlesUsecase implements UseCaseNoParams {
  GetArticlesUsecase(this.repository);

  final HomeRepository repository;

  @override
  Future<Either<Failure, ArticlesModel>> call() {
    return repository.getArticles();
  }
}
