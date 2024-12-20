import 'package:equatable/equatable.dart';

class DetailPermitRequestEntity extends Equatable {
  const DetailPermitRequestEntity(
      {required this.code, required this.message, required this.data});

  final int code;
  final String message;
  final List<DetailPermitData> data;

  @override
  List<Object?> get props => [code, message, data];
}

class DetailPermitData {
  final String attendanceCode;
  final Shiftstart shiftstartTime;
  final Shiftstart shiftstartAbsence;

  DetailPermitData({
    required this.attendanceCode,
    required this.shiftstartTime,
    required this.shiftstartAbsence,
  });

  factory DetailPermitData.fromJson(Map<String, dynamic> json) =>
      DetailPermitData(
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
