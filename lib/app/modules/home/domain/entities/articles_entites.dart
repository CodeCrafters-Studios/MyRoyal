import 'package:equatable/equatable.dart';

class ArticlesEntites extends Equatable {
  final List<ArticlesData> data;
  final int total;

  const ArticlesEntites({
    required this.data,
    required this.total,
  });

  @override
  List<Object?> get props => [data, total];
}

class ArticlesData {
  final int id;
  final String slug;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int ownedBy;
  final int createdBy;
  final int updatedBy;

  ArticlesData({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.ownedBy,
    required this.createdBy,
    required this.updatedBy,
  });

  factory ArticlesData.fromJson(Map<String, dynamic> json) => ArticlesData(
        id: json["id"],
        slug: json["slug"],
        name: json["name"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        ownedBy: json["owned_by"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slug": slug,
        "name": name,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "owned_by": ownedBy,
        "created_by": createdBy,
        "updated_by": updatedBy,
      };
}
