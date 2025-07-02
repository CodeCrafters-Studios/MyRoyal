import 'package:iroyal/app/modules/cam_app_reserved_by/domain/entities/update_reserved_by_params_entity.dart';

class UpdateReservedByParamsModel extends UpdateReservedByParamsEntity {
  UpdateReservedByParamsModel({
    required super.userJde,
    required super.company,
    required super.genericKey,
  });

  factory UpdateReservedByParamsModel.fromJson(Map<String, dynamic> json) =>
      UpdateReservedByParamsModel(
        userJde: json["user_jde"],
        company: json["company"],
        genericKey: json["generic_key"],
      );

  Map<String, dynamic> toJson() => {
        "user_jde": userJde,
        "company": company,
        "generic_key": genericKey,
      };
}
