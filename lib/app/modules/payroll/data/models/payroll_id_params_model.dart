import 'package:iroyal/app/modules/payroll/domain/entities/payroll_id_params_entity.dart';

class PayrollIdParamsModel extends PayrollIdParamsEntity {
  const PayrollIdParamsModel({required super.payrollId});

  factory PayrollIdParamsModel.fromJson(Map<String, dynamic> json) =>
      PayrollIdParamsModel(
        payrollId: json["payroll_id"],
      );

  Map<String, dynamic> toJson() => {
        "payroll_id": payrollId,
      };
}
