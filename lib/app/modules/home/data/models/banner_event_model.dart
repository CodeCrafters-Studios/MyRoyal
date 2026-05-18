import 'package:MyRoyal/app/modules/home/domain/entities/banner_event_entity.dart';

class BannerEventModel extends BannerEventEntity {
  BannerEventModel({
    required super.img,
    required super.url,
  });

  factory BannerEventModel.fromJson(Map<String, dynamic> json) =>
      BannerEventModel(
        img: json["img"],
        url: json["url"],
      );

  factory BannerEventModel.empty() => BannerEventModel(
        img: '',
        url: '',
      );

  Map<String, dynamic> toJson() => {
        "img": img,
        "url": url,
      };
}
