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
  final String label;
  final String filename;
  final String value;
  final String periodId;

  PayrollPeriodData({
    required this.label,
    required this.value,
    required this.filename,
    required this.periodId,
  });

  factory PayrollPeriodData.fromJson(Map<String, dynamic> json) =>
      PayrollPeriodData(
        label: json["label"],
        value: json["value"],
        filename: json["filename"],
        periodId: json["period_id"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
        "filename": filename,
        "period_id": periodId,
      };
}
