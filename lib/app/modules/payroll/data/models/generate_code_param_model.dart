import 'package:MyRoyal/app/modules/payroll/domain/entities/generate_code_params_entity.dart';

class GenerateCodeParamModel extends GenerateCodeParamsEntity {
  const GenerateCodeParamModel(
      {required super.payrollPeriodId, required super.valueMonth});

  factory GenerateCodeParamModel.fromJson(Map<String, dynamic> json) =>
      GenerateCodeParamModel(
        valueMonth: json["value_month"],
        payrollPeriodId: json["period_id"],
      );

  Map<String, dynamic> toJson() => {
        "value_month": valueMonth,
        "period_id": payrollPeriodId,
      };
}
