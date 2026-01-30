import 'package:equatable/equatable.dart';

class DetailPermitRequestEntity extends Equatable {
  const DetailPermitRequestEntity(
      {required this.code, required this.message, required this.data});

  final int code;
  final String message;
  final List<DetailPermitRequestData> data;

  @override
  List<Object?> get props => [code, message, data];
}

class DetailPermitRequestData {
  final int id;
  final String employeeId;
  final String reason;
  final List<String> periodDate;
  final PeriodTime periodTime;
  final String code;
  final String codeDefine;

  DetailPermitRequestData({
    required this.id,
    required this.employeeId,
    required this.reason,
    required this.periodDate,
    required this.periodTime,
    required this.code,
    required this.codeDefine,
  });

  factory DetailPermitRequestData.fromJson(Map<String, dynamic> json) =>
      DetailPermitRequestData(
        id: json["id"],
        employeeId: json["employee_id"],
        reason: json["reason"],
        periodDate: List<String>.from(json["period_date"].map((x) => x)),
        periodTime: PeriodTime.fromJson(json["period_time"]),
        code: json["code"],
        codeDefine: json["code_define"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employeeId,
        "reason": reason,
        "period_date": List<dynamic>.from(periodDate.map((x) => x)),
        "period_time": periodTime.toJson(),
        "code": code,
        "code_define": codeDefine,
      };
}

class PeriodTime {
  final String start;
  final String end;

  PeriodTime({
    required this.start,
    required this.end,
  });

  factory PeriodTime.fromJson(Map<String, dynamic> json) => PeriodTime(
        start: json["start"],
        end: json["end"],
      );

  Map<String, dynamic> toJson() => {
        "start": start,
        "end": end,
      };
}
