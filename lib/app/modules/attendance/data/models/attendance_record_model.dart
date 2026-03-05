import 'package:iroyal/app/modules/attendance/domain/entities/attendance_record_entity.dart';

class AttendanceRecordModel extends AttendanceRecordEntity {
  const AttendanceRecordModel({
    required super.status,
    required super.date,
    required super.time,
    required super.latitude,
    required super.longitude,
    required super.workDurationMinutes,
  });

  Map<String, dynamic> toJson() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final dateStr =
        "${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)}";

    final timeStr =
        "${twoDigits(time.hour)}:${twoDigits(time.minute)}:${twoDigits(time.second)}";

    return {
      "status": status,
      "date": dateStr,
      "time": timeStr,
      "latitude": latitude.toString(),
      "longtitude": longitude.toString(),
      "work_duration_minutes": workDurationMinutes,
    };
  }
}
