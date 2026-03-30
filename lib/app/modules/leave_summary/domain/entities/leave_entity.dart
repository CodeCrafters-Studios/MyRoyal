import 'package:equatable/equatable.dart';
import 'package:MyRoyal/app/modules/leave_summary/data/models/leave_data_model.dart';

class LeaveEntity extends Equatable {
  const LeaveEntity(
      {required this.code, required this.message, required this.data});

  final int? code;
  final String? message;
  final LeaveDataModel? data;

  @override
  List<Object?> get props => [code, message, data];
}
