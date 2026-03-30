import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/detail_tracking_document/domain/entities/action_tracking_document_entity.dart';
import 'package:MyRoyal/app/modules/detail_tracking_document/domain/entities/detail_tracking_document_entity.dart';
import 'package:MyRoyal/base/errors/failures.dart';

abstract class DetailTrackingDocumentRepository {
  Future<Either<Failure, DetailTrackingDocumentEntity>>
      getDetailTrackingDocument(params);
  Future<Either<Failure, ActionTrackingDocumentEntity>>
      postActionDetailTrackingDocument(Map<String, dynamic> params);
}
