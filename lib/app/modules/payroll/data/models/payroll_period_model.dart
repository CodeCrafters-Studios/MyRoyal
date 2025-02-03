import 'package:iroyal/app/modules/payroll/domain/entities/payroll_period_entity.dart';

class PayrollPeriodModel extends PayrollPeriodEntity {
  const PayrollPeriodModel(
      {required super.code, required super.message, required super.data});

  factory PayrollPeriodModel.fromJson(Map<String, dynamic> json) =>
      PayrollPeriodModel(
        code: json["code"],
        message: json["message"],
        data: List<PayrollPeriodData>.from(
            json["data"].map((x) => PayrollPeriodData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
