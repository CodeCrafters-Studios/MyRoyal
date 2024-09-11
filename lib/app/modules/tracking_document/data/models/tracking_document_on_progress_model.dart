import 'package:iroyal/app/modules/tracking_document/data/models/tracking_document_list_on_progress_model.dart';
import 'package:iroyal/app/modules/tracking_document/domain/entities/tracking_document_on_progress.dart';

class TrackingDocumentOnProgressModel extends TrackingDocumentOnProgress {
  const TrackingDocumentOnProgressModel(super.code, super.message, super.data);

  factory TrackingDocumentOnProgressModel.fromJson(Map<String, dynamic> json) =>
      TrackingDocumentOnProgressModel(
        json["code"],
        json["message"],
        List<TrackingDocumentListOnProgressModel>.from(json["data"]
            .map((x) => TrackingDocumentListOnProgressModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
