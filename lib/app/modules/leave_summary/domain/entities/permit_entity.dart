import 'package:equatable/equatable.dart';
import 'package:MyRoyal/app/modules/leave_summary/data/models/permit_data_model.dart';

class PermitEntity extends Equatable {
  const PermitEntity(
      {required this.code, required this.message, required this.data});

  final int code;
  final String message;
  final List<PermitDataModel> data;

  @override
  List<Object?> get props => [code, message, data];
}
