import 'package:MyRoyal/app/modules/payroll/domain/entities/payroll_download_url_entity.dart';

class PayrollDownloadUrlModel extends PayrollDownloadUrlEntity {
  const PayrollDownloadUrlModel(
      {required super.code, required super.message, required super.data});

  factory PayrollDownloadUrlModel.fromJson(Map<String, dynamic> json) =>
      PayrollDownloadUrlModel(
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
