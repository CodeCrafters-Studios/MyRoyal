import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/detail_tracking_document/domain/entities/detail_tracking_document_entity.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class DetailTrackingDocumentRepository {
  Future<Either<Failure, DetailTrackingDocumentEntity>>
      getDetailTrackingDocument(params);
}
