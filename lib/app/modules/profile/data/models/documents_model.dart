import 'package:MyRoyal/app/modules/profile/domain/entities/documents.dart';

class DocumentsModel extends Documents {
  const DocumentsModel({
    required super.name,
    required super.type,
    required super.url,
    required super.ext,
  });

  factory DocumentsModel.empty() =>
      const DocumentsModel(name: ' ', type: '', url: '', ext: '');

  factory DocumentsModel.fromJson(Map<String, dynamic> json) => DocumentsModel(
        name: json["name"],
        type: json["type"],
        url: json["url"],
        ext: json["ext"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "url": url,
        "ext": ext,
      };
}
