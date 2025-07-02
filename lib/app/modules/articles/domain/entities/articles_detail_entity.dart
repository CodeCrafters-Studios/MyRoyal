class ArticlesDetailEntity {
  final int id;
  final String name;
  final String slug;
  final String description;
  final EdBy createdBy;
  final EdBy updatedBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final EdBy ownedBy;
  final String descriptionHtml;
  final List<Tag> tags;
  final Cover cover;
  final List<Book> books;

  ArticlesDetailEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.ownedBy,
    required this.descriptionHtml,
    required this.tags,
    required this.cover,
    required this.books,
  });
}

class Book {
  final int id;
  final String name;
  final String slug;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int createdBy;
  final int updatedBy;
  final int ownedBy;
  final dynamic defaultTemplateId;

  Book({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.ownedBy,
    required this.defaultTemplateId,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        ownedBy: json["owned_by"],
        defaultTemplateId: json["default_template_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "created_by": createdBy,
        "updated_by": updatedBy,
        "owned_by": ownedBy,
        "default_template_id": defaultTemplateId,
      };
}

class Cover {
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

  Cover({
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

  factory Cover.fromJson(Map<String, dynamic> json) => Cover(
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

class EdBy {
  final int id;
  final String name;
  final String slug;

  EdBy({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory EdBy.fromJson(Map<String, dynamic> json) => EdBy(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
      };
}

class Tag {
  final String name;
  final String value;
  final int order;

  Tag({
    required this.name,
    required this.value,
    required this.order,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        name: json["name"],
        value: json["value"],
        order: json["order"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "value": value,
        "order": order,
      };
}
