import 'package:equatable/equatable.dart';

class PayrollPeriodParamsEntity extends Equatable {
  const PayrollPeriodParamsEntity({
    required this.payrollPeriod,
    required this.filename,
    required this.periodID,
  });

  final String payrollPeriod, filename, periodID;

  @override
  List<Object?> get props => [payrollPeriod, filename, periodID];
}
