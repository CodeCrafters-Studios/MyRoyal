import 'package:iroyal/app/modules/tracking_document/data/models/tracking_document_list_history_model.dart';
import 'package:iroyal/app/modules/tracking_document/domain/entities/tracking_document_history.dart';

class TrackingDocumentHistoryModel extends TrackingDocumentHistory {
  const TrackingDocumentHistoryModel(
      {required super.code, required super.message, required super.data});

  factory TrackingDocumentHistoryModel.fromJson(Map<String, dynamic> json) =>
      TrackingDocumentHistoryModel(
        code: json["code"],
        message: json["message"],
        data: List<TrackingDocumentListHistoryModel>.from(json["data"]
            .map((x) => TrackingDocumentListHistoryModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
