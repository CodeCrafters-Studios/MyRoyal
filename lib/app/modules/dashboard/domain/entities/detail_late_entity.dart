import 'package:equatable/equatable.dart';

class DetailLateEntity extends Equatable {
  const DetailLateEntity(
      {required this.code, required this.message, required this.data});

  final int code;
  final String message;
  final List<DetailLateData> data;

  @override
  List<Object?> get props => [code, message, data];
}

class DetailLateData {
  final String attendanceCode;
  final Shiftstart shiftstartTime;
  final Shiftstart shiftstartAbsence;

  DetailLateData({
    required this.attendanceCode,
    required this.shiftstartTime,
    required this.shiftstartAbsence,
  });

  factory DetailLateData.fromJson(Map<String, dynamic> json) => DetailLateData(
        attendanceCode: json["attendance_code"],
        shiftstartTime: Shiftstart.fromJson(json["shiftstart_time"]),
        shiftstartAbsence: Shiftstart.fromJson(json["shiftstart_absence"]),
      );

  Map<String, dynamic> toJson() => {
        "attendance_code": attendanceCode,
        "shiftstart_time": shiftstartTime.toJson(),
        "shiftstart_absence": shiftstartAbsence.toJson(),
      };
}

class Shiftstart {
  final DateTime date;
  final String time;

  Shiftstart({
    required this.date,
    required this.time,
  });

  factory Shiftstart.fromJson(Map<String, dynamic> json) => Shiftstart(
        date: DateTime.parse(json["date"]),
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "time": time,
      };
}
