import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/tracking_document/domain/entities/tracking_document_history.dart';
import 'package:MyRoyal/app/modules/tracking_document/domain/entities/tracking_document_on_progress.dart';
import 'package:MyRoyal/base/errors/failures.dart';

abstract class TrackingDocumentRepository {
  Future<Either<Failure, TrackingDocumentOnProgress>>
      getTrackingDocumentOnProgress();
  Future<Either<Failure, TrackingDocumentHistory>> getTrackingDocumentHistory();
}
