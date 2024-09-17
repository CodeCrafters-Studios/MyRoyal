import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/tracking_document/data/models/tracking_document_list_history_model.dart';

class TrackingDocumentHistory extends Equatable {
  const TrackingDocumentHistory(
      {required this.code, required this.message, required this.data});

  final int code;
  final String message;
  final List<TrackingDocumentListHistoryModel> data;

  @override
  List<Object?> get props => [code, message, data];
}
