import 'package:iroyal/app/modules/online_app/cam/cam_app_release_order/domain/entities/update_release_order_params_entity.dart';

class UpdateReleaseOrderParamsModel extends UpdateReleaseOrderParamsEntity {
  UpdateReleaseOrderParamsModel({
    required super.userJde,
    required super.nomorOrder,
    required super.kodeHold,
    required super.tipeOrder,
    required super.branchPlant,
    required super.company,
  });

  factory UpdateReleaseOrderParamsModel.fromJson(Map<String, dynamic> json) =>
      UpdateReleaseOrderParamsModel(
        userJde: json["user_jde"],
        nomorOrder: json["nomor_order"],
        kodeHold: json["kode_hold"],
        tipeOrder: json["tipe_order"],
        branchPlant: json["branch_plant"],
        company: json["company"],
      );

  Map<String, dynamic> toJson() => {
        "user_jde": userJde,
        "nomor_order": nomorOrder,
        "kode_hold": kodeHold,
        "tipe_order": tipeOrder,
        "branch_plant": branchPlant,
        "company": company,
      };
}
