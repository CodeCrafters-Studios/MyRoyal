import 'package:MyRoyal/app/modules/detail_tracking_document/domain/entities/action_tracking_document_entity.dart';

class ActionTrackingDocumentModel extends ActionTrackingDocumentEntity {
  const ActionTrackingDocumentModel({
    required super.code,
    required super.message,
    required super.data,
  });

  factory ActionTrackingDocumentModel.empty() =>
      const ActionTrackingDocumentModel(code: 0, message: '', data: '');

  factory ActionTrackingDocumentModel.fromJson(Map<String, dynamic> json) =>
      ActionTrackingDocumentModel(
        code: json["code"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data,
      };
}
