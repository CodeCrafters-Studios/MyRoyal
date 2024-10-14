import 'package:iroyal/app/modules/leave_summary/data/models/data_leave_model.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/year_leave_count_model.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/leave_data_entity.dart';

class LeaveDataModel extends LeaveDataEntity {
  const LeaveDataModel(
      {required super.yearlyLeaveCount, required super.dataLeave});

  factory LeaveDataModel.empty() => LeaveDataModel(
        yearlyLeaveCount: YearLeaveCountModel.empty(),
        dataLeave: const [],
      );

  factory LeaveDataModel.fromJson(Map<String, dynamic> json) => LeaveDataModel(
        yearlyLeaveCount:
            YearLeaveCountModel.fromJson(json["yearly_leave_count"]),
        dataLeave: List<DataLeaveModel>.from(
            json["data_leave"].map((x) => DataLeaveModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "yearly_leave_count": yearlyLeaveCount!.toJson(),
        "data_leave": List<dynamic>.from(dataLeave!.map((x) => x.toJson())),
      };
}
