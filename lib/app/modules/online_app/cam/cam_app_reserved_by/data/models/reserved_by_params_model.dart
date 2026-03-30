import 'package:MyRoyal/app/modules/online_app/cam/cam_app_reserved_by/domain/entities/reserved_by_params_entity.dart';

class ReservedByParamsModel extends ReservedByParamsEntity {
  ReservedByParamsModel({required super.userJde, required super.company});

  factory ReservedByParamsModel.fromJson(Map<String, dynamic> json) =>
      ReservedByParamsModel(
        userJde: json["user_jde"],
        company: json["company"],
      );

  Map<String, dynamic> toJson() => {
        "user_jde": userJde,
        "company": company,
      };
}
