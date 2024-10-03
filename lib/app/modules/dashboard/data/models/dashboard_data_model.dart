import 'package:iroyal/app/modules/dashboard/data/models/leave_balance_model.dart';
import 'package:iroyal/app/modules/dashboard/data/models/leave_summary_model.dart';
import 'package:iroyal/app/modules/dashboard/data/models/ptk_model.dart';
import 'package:iroyal/app/modules/dashboard/domain/entities/dashboard_data_entity.dart';

class DashboardDataModel extends DashboardDataEntity {
  const DashboardDataModel({
    required super.leaveBalance,
    required super.leaveSummary,
    required super.ptk,
  });

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) =>
      DashboardDataModel(
        leaveBalance: json["leave_balance"] == null
            ? null
            : LeaveBalanceModel.fromJson(json["leave_balance"]),
        leaveSummary: json["leave_summary"] == null
            ? null
            : LeaveSummaryModel.fromJson(json["leave_summary"]),
        ptk: json["ptk"] == null ? null : PtkModel.fromJson(json["ptk"]),
      );

  Map<String, dynamic> toJson() => {
        "leave_balance": leaveBalance?.toJson(),
        "leave_summary": leaveSummary?.toJson(),
        "ptk": ptk?.toJson(),
      };
}
