import 'package:equatable/equatable.dart';

class DashboardPermitEntity extends Equatable {
  const DashboardPermitEntity({required this.count});

  final int count;

  @override
  List<Object?> get props => [count];
}
