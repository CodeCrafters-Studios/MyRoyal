import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/tracking_document/domain/entities/tracking_document_on_progress.dart';
import 'package:iroyal/app/modules/tracking_document/domain/repositories/tracking_document_repositories.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetTrackingDocumentOnProgress
    implements UseCaseNoParams<TrackingDocumentOnProgress> {
  GetTrackingDocumentOnProgress(this.repository);

  final TrackingDocumentRepository repository;

  @override
  Future<Either<Failure, TrackingDocumentOnProgress>> call() {
    return repository.getTrackingDocumentOnProgress();
  }
}
