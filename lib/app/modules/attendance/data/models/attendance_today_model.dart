class AttendanceTodayModel {
  final int? attendanceId;
  final DateTime? date;
  final String status;
  final String? checkedInTime;
  final String? checkedOutTime;
  final String? breakStartTime;
  final String? breakEndTime;
  final String? serverTime;
  final int? durationBreak;

  AttendanceTodayModel({
    this.attendanceId,
    this.date,
    required this.status,
    this.checkedInTime,
    this.checkedOutTime,
    this.breakStartTime,
    this.breakEndTime,
    this.serverTime,
    this.durationBreak,
  });

  factory AttendanceTodayModel.fromJson(Map<String, dynamic> json) {
    return AttendanceTodayModel(
      attendanceId: json["attendance_id"] ?? 0,
      date: json["date"] != null ? DateTime.parse(json["date"]) : null,
      status: json["status"] ?? '',
      checkedInTime: json["checked_in_time"],
      checkedOutTime: json["checked_out_time"],
      breakStartTime: json["break_start_time"],
      breakEndTime: json["break_end_time"],
      serverTime: json["server_time"],
      durationBreak: json["duration_break"] ?? 0,
    );
  }

  factory AttendanceTodayModel.empty() {
    return AttendanceTodayModel(
      attendanceId: 0,
      date: null,
      status: '',
      checkedInTime: '',
      checkedOutTime: '',
      breakStartTime: '',
      breakEndTime: '',
      serverTime: '',
      durationBreak: 0,
    );
  }
}
