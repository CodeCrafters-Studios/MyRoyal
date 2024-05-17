import 'package:iroyal/app/modules/home/domain/entities/attendance.dart';

class AttendanceModel extends Attendance {
  const AttendanceModel({
    required super.todayCheckin,
    required super.yesterdayCheckin,
    required super.yesterdayCheckout,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      AttendanceModel(
        todayCheckin: json['today_checkin'],
        yesterdayCheckin: json['yesterday_checkin'],
        yesterdayCheckout: json['yesterday_checkout'],
      );

  Map<String, dynamic> toJson() => {
        'today_checkin': todayCheckin,
        'yesterday_checkin': yesterdayCheckin,
        'yesterday_checkout': yesterdayCheckout,
      };
}
