class AttendanceTodayModel {
  final DateTime? date;
  final String status;
  final String? checkedInTime;
  final String? checkedOutTime;
  final String? breakStartTime;
  final String? breakEndTime;

  AttendanceTodayModel({
    this.date,
    required this.status,
    this.checkedInTime,
    this.checkedOutTime,
    this.breakStartTime,
    this.breakEndTime,
  });

  factory AttendanceTodayModel.fromJson(Map<String, dynamic> json) {
    return AttendanceTodayModel(
      date: json["date"] != null ? DateTime.parse(json["date"]) : null,
      status: json["status"] ?? '',
      checkedInTime: json["checked_in_time"],
      checkedOutTime: json["checked_out_time"],
      breakStartTime: json["break_start_time"],
      breakEndTime: json["break_end_time"],
    );
  }
}
