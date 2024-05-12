import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/tracking_document/domain/entities/tracking_document.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class TrackingDocumentRepository {
  Future<Either<Failure, List<TrackingDocument>>> getTrackingDocument();
}
