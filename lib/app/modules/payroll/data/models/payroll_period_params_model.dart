import 'package:MyRoyal/app/modules/payroll/domain/entities/payroll_period_params_entity.dart';

class PayrollPeriodParamsModel extends PayrollPeriodParamsEntity {
  const PayrollPeriodParamsModel(
      {required super.payrollPeriod, required super.filename});

  factory PayrollPeriodParamsModel.fromJson(Map<String, dynamic> json) =>
      PayrollPeriodParamsModel(
        payrollPeriod: json["value_month"],
        filename: json["filename"],
      );

  Map<String, dynamic> toJson() => {
        "value_month": payrollPeriod,
        "filename": filename,
      };
}
