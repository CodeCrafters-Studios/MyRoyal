import 'package:equatable/equatable.dart';

class GenerateCodeParamsEntity extends Equatable {
  const GenerateCodeParamsEntity({
    required this.payrollPeriodId,
    required this.valueMonth,
  });

  final String payrollPeriodId, valueMonth;

  @override
  List<Object?> get props => [payrollPeriodId, valueMonth];
}
