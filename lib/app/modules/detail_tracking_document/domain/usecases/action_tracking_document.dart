import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:MyRoyal/app/modules/detail_tracking_document/domain/entities/action_tracking_document_entity.dart';
import 'package:MyRoyal/app/modules/detail_tracking_document/domain/repositories/detail_tracking_document_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class ActionTrackingDocument
    implements UseCase<ActionTrackingDocumentEntity, Map<String, dynamic>> {
  ActionTrackingDocument(this.repository);

  final DetailTrackingDocumentRepository repository;

  @override
  Future<Either<Failure, ActionTrackingDocumentEntity>> call(
      Map<String, dynamic> params) {
    return repository.postActionDetailTrackingDocument(params);
  }
}

class ParamsActionDocument extends Equatable {
  const ParamsActionDocument(
      {required this.laborId, required this.type, required this.feedback});

  final int laborId;
  final String type;
  final String feedback;

  @override
  List<Object?> get props => [laborId, type, feedback];
}
