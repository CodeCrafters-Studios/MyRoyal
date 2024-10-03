import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/data_leave_model.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/year_leave_count_model.dart';

class LeaveDataEntity extends Equatable {
  const LeaveDataEntity(
      {required this.yearlyLeaveCount, required this.dataLeave});

  final YearLeaveCountModel? yearlyLeaveCount;
  final DataLeaveModel? dataLeave;

  @override
  List<Object?> get props => [yearlyLeaveCount, dataLeave];
}
