import 'package:equatable/equatable.dart';

class LeaveBalanceEntity extends Equatable {
  const LeaveBalanceEntity(this.balance, this.used);

  final int? balance;
  final int? used;

  @override
  List<Object?> get props => [balance, used];
}
