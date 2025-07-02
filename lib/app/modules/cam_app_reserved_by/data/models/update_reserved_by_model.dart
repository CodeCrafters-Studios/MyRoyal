import 'package:iroyal/app/modules/cam_app_reserved_by/domain/entities/update_reserved_by_entity.dart';

class UpdateReservedByModel extends UpdateReservedByEntity {
  UpdateReservedByModel(
      {required super.code, required super.message, required super.data});

  factory UpdateReservedByModel.fromJson(Map<String, dynamic> json) =>
      UpdateReservedByModel(
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}
