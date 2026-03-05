import 'package:equatable/equatable.dart';

class AttendanceRecordEntity extends Equatable {
  final String status;
  final DateTime date;
  final DateTime time;
  final double latitude;
  final double longitude;
  final int workDurationMinutes;

  const AttendanceRecordEntity({
    required this.status,
    required this.date,
    required this.time,
    required this.latitude,
    required this.longitude,
    required this.workDurationMinutes,
  });

  @override
  List<Object?> get props => [
        status,
        date,
        time,
        latitude,
        longitude,
        workDurationMinutes,
      ];
}
