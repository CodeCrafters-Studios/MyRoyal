import 'package:iroyal/app/modules/leave_summary/data/models/data_leave_model.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/year_leave_count_model.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/leave_data_entity.dart';

class LeaveDataModel extends LeaveDataEntity {
  const LeaveDataModel(
      {required super.yearlyLeaveCount, required super.dataLeave});

  factory LeaveDataModel.empty() => LeaveDataModel(
      yearlyLeaveCount: YearLeaveCountModel.empty(),
      dataLeave: DataLeaveModel.empty());

  factory LeaveDataModel.fromJson(Map<String, dynamic> json) => LeaveDataModel(
        yearlyLeaveCount: json["yearly_leave_count"] == null
            ? null
            : YearLeaveCountModel.fromJson(json["yearly_leave_count"]),
        dataLeave: json["data_leave"] == null
            ? null
            : DataLeaveModel.fromJson(json["data_leave"]),
      );

  Map<String, dynamic> toJson() => {
        "yearly_leave_count": yearlyLeaveCount?.toJson(),
        "data_leave": dataLeave?.toJson(),
      };
}
