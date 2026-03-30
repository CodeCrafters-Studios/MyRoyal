import 'package:equatable/equatable.dart';
import 'package:MyRoyal/app/modules/tracking_document/data/models/tracking_document_list_on_progress_model.dart';

class TrackingDocumentOnProgress extends Equatable {
  const TrackingDocumentOnProgress(this.code, this.message, this.data);

  final int code;
  final String message;
  final List<TrackingDocumentListOnProgressModel> data;

  @override
  List<Object?> get props => [code, message, data];
}
