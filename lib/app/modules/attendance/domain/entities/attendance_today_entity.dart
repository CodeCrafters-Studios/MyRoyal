import 'package:equatable/equatable.dart';

class AttendanceTodayEntity extends Equatable {
  final DateTime date;
  final String status;

  AttendanceTodayEntity({
    required this.date,
    required this.status,
  });

  @override
  List<Object?> get props => [date, status];
}
