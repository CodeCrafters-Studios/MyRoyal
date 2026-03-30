import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/articles/data/models/books_detail_model.dart';
import 'package:MyRoyal/app/modules/articles/domain/repositories/articles_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class GetBooksDetailUsecase implements UseCase<BooksDetailModel, String> {
  GetBooksDetailUsecase(this.repository);

  final ArticlesRepository repository;

  @override
  Future<Either<Failure, BooksDetailModel>> call(String params) {
    return repository.getBooksDetail(params);
  }
}
