import 'package:MyRoyal/app/modules/detail_tracking_document/data/models/detail_progress_model.dart';
import 'package:MyRoyal/app/modules/detail_tracking_document/data/models/detail_ptk_model.dart';
import 'package:MyRoyal/app/modules/detail_tracking_document/domain/entities/detail_tracking_document_data_entities.dart';

class DetailTrackingDocumentDataModel
    extends DetailTrackingDocumentDataEntities {
  const DetailTrackingDocumentDataModel({
    required super.detailPtk,
    required super.detailProgress,
  });

  factory DetailTrackingDocumentDataModel.fromJson(Map<String, dynamic> json) =>
      DetailTrackingDocumentDataModel(
        detailPtk: DetailPtkModel.fromJson(json["detail_ptk"]),
        detailProgress: List<DetailProgressModel>.from(
            json["progress"].map((x) => DetailProgressModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "detail_ptk": detailPtk.toJson(),
        "progress": List<dynamic>.from(detailProgress.map((x) => x.toJson())),
      };
}
