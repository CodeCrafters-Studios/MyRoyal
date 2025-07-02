import 'package:iroyal/app/modules/articles/domain/entities/books_detail_entity.dart';

class BooksDetailModel extends BooksDetailEntity {
  const BooksDetailModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.description,
    required super.createdAt,
    required super.updatedAt,
    required super.descriptionHtml,
    required super.cover,
  });

  factory BooksDetailModel.fromJson(Map<String, dynamic> json) =>
      BooksDetailModel(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        descriptionHtml: json["description_html"],
        cover: CoverBooks.fromJson(json["cover"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "description_html": descriptionHtml,
        "cover": cover.toJson(),
      };
}
