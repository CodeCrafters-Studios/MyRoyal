import 'package:iroyal/app/modules/payroll/domain/entities/payroll_data_overview_entity.dart';

class PayrollDataOverviewModel extends PayrollDataOverviewEntity {
  const PayrollDataOverviewModel({required super.data});

  factory PayrollDataOverviewModel.fromJson(Map<String, dynamic> json) =>
      PayrollDataOverviewModel(
        data: DataOverview.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}
