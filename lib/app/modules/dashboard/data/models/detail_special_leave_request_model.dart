import 'package:iroyal/app/modules/dashboard/domain/entities/detail_special_leave_request_entity.dart';

class DetailSpecialLeaveRequestModel extends DetailSpecialLeaveRequestEntity {
  const DetailSpecialLeaveRequestModel(
      {required super.code, required super.message, required super.data});

  factory DetailSpecialLeaveRequestModel.fromJson(Map<String, dynamic> json) =>
      DetailSpecialLeaveRequestModel(
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
