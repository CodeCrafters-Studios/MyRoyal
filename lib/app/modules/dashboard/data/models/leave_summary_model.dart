import 'package:iroyal/app/modules/dashboard/domain/entities/leave_summary_entity.dart';

class LeaveSummaryModel extends LeaveSummaryEntity {
  const LeaveSummaryModel(super.late, super.absent, super.specialLeaves);

  factory LeaveSummaryModel.fromJson(Map<String, dynamic> json) =>
      LeaveSummaryModel(
        json["late"],
        json["absent"],
        json["special_leaves"],
      );

  Map<String, dynamic> toJson() => {
        "late": late,
        "absent": absent,
        "special_leaves": specialLeaves,
      };
}
