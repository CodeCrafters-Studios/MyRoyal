import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/detail_tracking_document/domain/repositories/detail_tracking_document_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class GetDetailTrackingDocument implements UseCase {
  GetDetailTrackingDocument(this.repository);

  final DetailTrackingDocumentRepository repository;

  @override
  Future<Either<Failure, dynamic>> call(params) {
    return repository.getDetailTrackingDocument(params);
  }
}
