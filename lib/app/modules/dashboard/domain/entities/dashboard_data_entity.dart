import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/dashboard/data/models/leave_balance_model.dart';
import 'package:iroyal/app/modules/dashboard/data/models/leave_summary_model.dart';
import 'package:iroyal/app/modules/dashboard/data/models/ptk_model.dart';

class DashboardDataEntity extends Equatable {
  const DashboardDataEntity({
    required this.leaveBalance,
    required this.leaveSummary,
    required this.ptk,
  });

  final LeaveBalanceModel? leaveBalance;
  final LeaveSummaryModel? leaveSummary;
  final PtkModel? ptk;

  @override
  List<Object?> get props => [leaveBalance, leaveSummary, ptk];
}
