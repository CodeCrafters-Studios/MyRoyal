import 'package:MyRoyal/app/modules/online_app/cam/cam_app_reserved_by/domain/entities/reserved_by_entity.dart'; // Ensure this path is correct

class ReservedByModel extends ReservedByEntity {
  const ReservedByModel({
    required super.code,
    required super.message,
    super.data,
  });

  factory ReservedByModel.fromJson(Map<String, dynamic> json) {
    ReservedByData? reservedByData;
    if (json["data"] is Map<String, dynamic>) {
      reservedByData = ReservedByData.fromJson(json["data"]);
    } else if (json["data"] is List && (json["data"] as List).isEmpty) {
      reservedByData = ReservedByData(
        status: false,
        userid: '',
        data: [],
      );
    }

    return ReservedByModel(
      code: json["code"],
      message: json["message"],
      data: reservedByData,
    );
  }

  factory ReservedByModel.empty() => const ReservedByModel(
        code: 0,
        message: '',
        data: ReservedByData(
          status: false,
          userid: '',
          data: [],
        ),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data?.toJson() ?? [],
      };
}
