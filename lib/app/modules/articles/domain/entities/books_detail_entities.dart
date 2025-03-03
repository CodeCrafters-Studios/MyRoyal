import 'package:equatable/equatable.dart';

class BooksDetailEntities extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String descriptionHtml;
  final CoverBooks cover;

  const BooksDetailEntities({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.descriptionHtml,
    required this.cover,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        description,
        createdAt,
        updatedAt,
        descriptionHtml,
        cover,
      ];
}

class CoverBooks {
  final int id;
  final String name;
  final String url;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int createdBy;
  final int updatedBy;
  final String path;
  final String type;
  final int uploadedTo;

  CoverBooks({
    required this.id,
    required this.name,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.path,
    required this.type,
    required this.uploadedTo,
  });

  factory CoverBooks.fromJson(Map<String, dynamic> json) => CoverBooks(
        id: json["id"],
        name: json["name"],
        url: json["url"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        path: json["path"],
        type: json["type"],
        uploadedTo: json["uploaded_to"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "created_by": createdBy,
        "updated_by": updatedBy,
        "path": path,
        "type": type,
        "uploaded_to": uploadedTo,
      };
}
