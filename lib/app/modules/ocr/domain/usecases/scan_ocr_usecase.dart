import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/ocr/data/models/scan_ocr_request_model.dart';
import 'package:MyRoyal/app/modules/ocr/data/models/scan_ocr_response_model.dart';
import 'package:MyRoyal/app/modules/ocr/domain/repositories/ocr_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class ScanOcrUseCase
    implements UseCase<ScanOcrResponseModel, ScanOcrRequestModel> {
  final OcrRepository repository;

  ScanOcrUseCase(this.repository);

  @override
  Future<Either<Failure, ScanOcrResponseModel>> call(
      ScanOcrRequestModel params) {
    return repository.scanOcr(params);
  }
}
