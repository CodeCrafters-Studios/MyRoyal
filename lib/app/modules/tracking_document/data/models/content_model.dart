import 'package:iroyal/app/modules/tracking_document/domain/entities/content.dart';

class ContentModel extends Content {
  const ContentModel({
    required super.id,
    required super.name,
    required super.body,
    required super.recordType,
    required super.recordId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) => ContentModel(
        id: json["id"],
        name: json["name"],
        body: json["body"],
        recordType: json["record_type"],
        recordId: json["record_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "body": body,
        "record_type": recordType,
        "record_id": recordId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
