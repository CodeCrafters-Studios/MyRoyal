import 'package:equatable/equatable.dart';

class PayrollIdParamsEntity extends Equatable {
  const PayrollIdParamsEntity({
    required this.payrollId,
  });
  final int payrollId;

  @override
  List<Object?> get props => [payrollId];
}
