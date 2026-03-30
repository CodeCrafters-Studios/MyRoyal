import 'package:MyRoyal/app/modules/home/domain/entities/articles_entity.dart';

class ArticlesModel extends ArticlesEntites {
  const ArticlesModel({required super.data, required super.total});

  factory ArticlesModel.fromJson(Map<String, dynamic> json) => ArticlesModel(
        data: List<ArticlesData>.from(
            json["data"].map((x) => ArticlesData.fromJson(x))),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "total": total,
      };
}
