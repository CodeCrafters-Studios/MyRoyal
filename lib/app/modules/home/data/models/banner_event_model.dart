import 'package:MyRoyal/app/modules/home/domain/entities/banner_event_entity.dart';

class BannerEventModel extends BannerEventEntity {
  BannerEventModel({
    required super.code,
    required super.message,
    required super.data,
  });

  factory BannerEventModel.fromJson(Map<String, dynamic> json) =>
      BannerEventModel(
        code: json["code"],
        message: json["message"],
        data: json["data"],
      );

  factory BannerEventModel.empty() => BannerEventModel(
        code: 400,
        message: '',
        data: '',
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data,
      };
}
