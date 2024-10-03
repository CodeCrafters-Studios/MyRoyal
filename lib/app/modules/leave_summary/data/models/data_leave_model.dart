import 'package:iroyal/app/modules/leave_summary/domain/entities/data_leave_entity.dart';

class DataLeaveModel extends DataLeaveEntity {
  const DataLeaveModel(
      {required super.specialLeave, required super.yearlyLeave});

  factory DataLeaveModel.empty() =>
      const DataLeaveModel(specialLeave: null, yearlyLeave: null);

  factory DataLeaveModel.fromJson(Map<String, dynamic> json) => DataLeaveModel(
        specialLeave: json["special_leave"],
        yearlyLeave: json["yearly_leave"],
      );

  Map<String, dynamic> toJson() => {
        "special_leave": specialLeave,
        "yearly_leave": yearlyLeave,
      };
}
