import 'package:MyRoyal/app/modules/dashboard/domain/entities/detail_permit_request_entity.dart';

class DetailPermitRequestModel extends DetailPermitRequestEntity {
  const DetailPermitRequestModel(
      {required super.code, required super.message, required super.data});

  factory DetailPermitRequestModel.fromJson(Map<String, dynamic> json) =>
      DetailPermitRequestModel(
        code: json["code"],
        message: json["message"],
        data: List<DetailPermitRequestData>.from(
            json["data"].map((x) => DetailPermitRequestData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
