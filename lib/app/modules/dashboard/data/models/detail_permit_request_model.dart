import 'package:iroyal/app/modules/dashboard/domain/entities/detail_late_entity.dart';

class DetailPermitRequestModel extends DetailLateEntity {
  const DetailPermitRequestModel(
      {required super.code, required super.message, required super.data});

  factory DetailPermitRequestModel.fromJson(Map<String, dynamic> json) =>
      DetailPermitRequestModel(
        code: json["code"],
        message: json["message"],
        data: List<DetailLateData>.from(
            json["data"].map((x) => DetailLateData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
