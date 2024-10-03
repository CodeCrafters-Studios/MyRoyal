import 'package:iroyal/app/modules/leave_summary/domain/entities/year_leave_count_entity.dart';

class YearLeaveCountModel extends YearLeaveCountEntity {
  const YearLeaveCountModel(
      {required super.used, required super.remaining, required super.max});

  factory YearLeaveCountModel.empty() =>
      const YearLeaveCountModel(used: 0, remaining: 0, max: 0);

  factory YearLeaveCountModel.fromJson(Map<String, dynamic> json) =>
      YearLeaveCountModel(
        used: json["used"],
        remaining: json["remaining"],
        max: json["max"],
      );

  Map<String, dynamic> toJson() => {
        "used": used,
        "remaining": remaining,
        "max": max,
      };
}
