import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/home/data/models/banner_event_model.dart';
import 'package:iroyal/app/modules/home/domain/repositories/home_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetBannerEventUsecase implements UseCaseNoParams {
  GetBannerEventUsecase(this.repository);

  final HomeRepository repository;

  @override
  Future<Either<Failure, BannerEventModel>> call() {
    return repository.getBannerEvent();
  }
}
