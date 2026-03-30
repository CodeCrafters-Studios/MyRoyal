import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/tracking_document/domain/entities/tracking_document_on_progress.dart';
import 'package:MyRoyal/app/modules/tracking_document/domain/repositories/tracking_document_repositories.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class GetTrackingDocumentOnProgress
    implements UseCaseNoParams<TrackingDocumentOnProgress> {
  GetTrackingDocumentOnProgress(this.repository);

  final TrackingDocumentRepository repository;

  @override
  Future<Either<Failure, TrackingDocumentOnProgress>> call() {
    return repository.getTrackingDocumentOnProgress();
  }
}
