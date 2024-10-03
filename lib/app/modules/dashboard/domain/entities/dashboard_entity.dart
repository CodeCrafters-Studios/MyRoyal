import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/dashboard/data/models/dashboard_data_model.dart';

class DashboardEntity extends Equatable {
  final int code;
  final String message;
  final DashboardDataModel? data;

  const DashboardEntity({
    required this.code,
    required this.message,
    required this.data,
  });

  @override
  List<Object?> get props => [code, message, data];
}
