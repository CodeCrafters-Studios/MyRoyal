import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/tracking_document/domain/entities/tracking_document_history.dart';
import 'package:iroyal/app/modules/tracking_document/domain/repositories/tracking_document_repositories.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetTrackingDocumentHistory
    implements UseCaseNoParams<TrackingDocumentHistory> {
  GetTrackingDocumentHistory(this.repository);

  final TrackingDocumentRepository repository;

  @override
  Future<Either<Failure, TrackingDocumentHistory>> call() {
    return repository.getTrackingDocumentHistory();
  }
}
