import 'package:MyRoyal/app/modules/dashboard/domain/entities/leave_balance_entity.dart';

class LeaveBalanceModel extends LeaveBalanceEntity {
  const LeaveBalanceModel(super.balance, super.used);

  factory LeaveBalanceModel.fromJson(Map<String, dynamic> json) =>
      LeaveBalanceModel(
        json["balance"],
        json["used"],
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "used": used,
      };
}
