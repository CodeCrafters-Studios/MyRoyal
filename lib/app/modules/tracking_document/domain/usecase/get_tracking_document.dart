import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/tracking_document/domain/entities/tracking_document.dart';
import 'package:iroyal/app/modules/tracking_document/domain/repositories/tracking_document_repositories.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetTrackingDocument implements UseCaseNoParams<List<TrackingDocument>> {
  GetTrackingDocument(this.repository);

  final TrackingDocumentRepository repository;

  @override
  Future<Either<Failure, List<TrackingDocument>>> call() {
    return repository.getTrackingDocument();
  }
}
