import 'package:equatable/equatable.dart';

class PayrollPeriodParamsEntity extends Equatable {
  const PayrollPeriodParamsEntity({
    required this.payrollPeriod,
    required this.filename,
  });

  final String payrollPeriod, filename;

  @override
  List<Object?> get props => [payrollPeriod, filename];
}
