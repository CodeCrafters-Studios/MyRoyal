import 'package:equatable/equatable.dart';

class PayrollPeriodEntity extends Equatable {
  final int code;
  final String message;
  final List<PayrollPeriodData> data;

  const PayrollPeriodEntity({
    required this.code,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [code, message, data];
}

class PayrollPeriodData {
  final int id;
  final String title;
  final DateTime start;
  final DateTime end;
  final String datePayroll;
  final String datePreviousPayroll;
  final String payrollPeriod;

  PayrollPeriodData({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    required this.datePayroll,
    required this.datePreviousPayroll,
    required this.payrollPeriod,
  });

  factory PayrollPeriodData.fromJson(Map<String, dynamic> json) =>
      PayrollPeriodData(
        id: json["id"],
        title: json["title"],
        start: DateTime.parse(json["start"]),
        end: DateTime.parse(json["end"]),
        datePayroll: json["date_payroll"],
        datePreviousPayroll: json["date_previous_payroll"],
        payrollPeriod: json["payroll_period"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "start":
            "${start.year.toString().padLeft(4, '0')}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}",
        "end":
            "${end.year.toString().padLeft(4, '0')}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}",
        "date_payroll": datePayroll,
        "date_previous_payroll": datePreviousPayroll,
        "payroll_period": payrollPeriod,
      };
}
