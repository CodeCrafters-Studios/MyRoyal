import 'package:equatable/equatable.dart';

class AttendanceRecordEntity extends Equatable {
  final int id;
  final int locationID;
  final String status;
  final DateTime date;
  final DateTime time;
  final double latitude;
  final double longitude;
  final int workDurationMinutes;
  final bool banned;
  final String file;

  const AttendanceRecordEntity({
    required this.id,
    required this.locationID,
    required this.status,
    required this.date,
    required this.time,
    required this.latitude,
    required this.longitude,
    required this.workDurationMinutes,
    required this.banned,
    required this.file,
  });

  @override
  List<Object?> get props => [
        id,
        locationID,
        status,
        date,
        time,
        latitude,
        longitude,
        workDurationMinutes,
        banned,
        file,
      ];
}
