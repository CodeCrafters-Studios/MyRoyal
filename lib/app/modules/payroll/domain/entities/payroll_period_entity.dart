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
  final String value;
  final String filename;

  PayrollPeriodData(
      {required this.label, required this.value, required this.filename});

  factory PayrollPeriodData.fromJson(Map<String, dynamic> json) =>
      PayrollPeriodData(
          label: json["label"],
          value: json["value"],
          filename: json["filename"]);

  Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
        "filename": filename,
      };
}
