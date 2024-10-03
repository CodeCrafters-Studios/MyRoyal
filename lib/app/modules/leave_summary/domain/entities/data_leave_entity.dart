import 'package:equatable/equatable.dart';

class DataLeaveEntity extends Equatable {
  const DataLeaveEntity(
      {required this.specialLeave, required this.yearlyLeave});

  final dynamic specialLeave;
  final dynamic yearlyLeave;

  @override
  List<Object?> get props => [specialLeave, yearlyLeave];
}
