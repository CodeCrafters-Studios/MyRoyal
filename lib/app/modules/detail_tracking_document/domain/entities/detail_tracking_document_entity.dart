import 'package:equatable/equatable.dart';
import 'package:MyRoyal/app/modules/detail_tracking_document/data/models/detail_tracking_document_data_model.dart';

class DetailTrackingDocumentEntity extends Equatable {
  const DetailTrackingDocumentEntity(
      {required this.code, required this.message, required this.data});

  final int code;
  final String message;
  final DetailTrackingDocumentDataModel data;

  @override
  List<Object?> get props => [code, message, data];
}
