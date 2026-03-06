import 'package:iroyal/app/modules/articles/domain/entities/articles_detail_entity.dart';

class ArticlesDetailModel extends ArticlesDetailEntity {
  ArticlesDetailModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.description,
    required super.createdBy,
    required super.updatedBy,
    required super.createdAt,
    required super.updatedAt,
    required super.ownedBy,
    required super.descriptionHtml,
    required super.tags,
    required super.cover,
    required super.books,
  });

  factory ArticlesDetailModel.fromJson(Map<String, dynamic> json) =>
      ArticlesDetailModel(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        description: json["description"],
        createdBy: EdBy.fromJson(json["created_by"]),
        updatedBy: EdBy.fromJson(json["updated_by"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        ownedBy: EdBy.fromJson(json["owned_by"]),
        descriptionHtml: json["description_html"],
        tags: List<Tag>.from(json["tags"].map((x) => Tag.fromJson(x))),
        cover: Cover.fromJson(json["cover"]),
        books: List<Book>.from(json["books"].map((x) => Book.fromJson(x))),
      );

  factory ArticlesDetailModel.empty() => ArticlesDetailModel(
        id: 0,
        name: '',
        slug: '',
        description: '',
        createdBy: EdBy(id: 0, name: '', slug: ''),
        updatedBy: EdBy(id: 0, name: '', slug: ''),
        createdAt: DateTime(0),
        updatedAt: DateTime(0),
        ownedBy: EdBy(id: 0, name: '', slug: ''),
        descriptionHtml: '',
        tags: [],
        cover: Cover(
          id: 0,
          name: '',
          url: '',
          createdAt: DateTime(0),
          updatedAt: DateTime(0),
          createdBy: 0,
          updatedBy: 0,
          path: '',
          type: '',
          uploadedTo: 0,
        ),
        books: [],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "description": description,
        "created_by": createdBy.toJson(),
        "updated_by": updatedBy.toJson(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "owned_by": ownedBy.toJson(),
        "description_html": descriptionHtml,
        "tags": List<dynamic>.from(tags.map((x) => x.toJson())),
        "cover": cover.toJson(),
        "books": List<dynamic>.from(books.map((x) => x.toJson())),
      };
}
