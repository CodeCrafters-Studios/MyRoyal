import 'package:iroyal/app/modules/detail_tracking_document/data/models/detail_ptk_model.dart';
import 'package:iroyal/app/modules/detail_tracking_document/data/models/detail_tracking_document_data_model.dart';
import 'package:iroyal/app/modules/detail_tracking_document/data/models/user_created_model.dart';
import 'package:iroyal/app/modules/detail_tracking_document/domain/entities/detail_tracking_document_entity.dart';

class DetailTrackingDocumentModel extends DetailTrackingDocumentEntity {
  const DetailTrackingDocumentModel(
      {required super.code, required super.message, required super.data});

  factory DetailTrackingDocumentModel.empty() => DetailTrackingDocumentModel(
        code: 0,
        message: '',
        data: DetailTrackingDocumentDataModel(
          detailPtk: DetailPtkModel.empty(),
          detailUserCreated: DetailUserCreatedModel.empty(),
          detailProgress: const [],
        ),
      );

  factory DetailTrackingDocumentModel.fromJson(Map<String, dynamic> json) =>
      DetailTrackingDocumentModel(
        code: json["code"],
        message: json["message"],
        data: DetailTrackingDocumentDataModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}
