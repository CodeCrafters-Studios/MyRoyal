import 'package:MyRoyal/app/modules/ocr/models/employee_os_model.dart';
import 'package:equatable/equatable.dart';

class EmployeeOsEntity extends Equatable {
  const EmployeeOsEntity({
    required this.currentPage,
    required this.data,
    required this.totalPage,
  });

  final int currentPage;
  final List<EmployeeOsDataModel> data;
  final int totalPage;

  @override
  List<Object?> get props => [currentPage, data, totalPage];
}

class EmployeeOsDataEntity {
  final int id;
  final String noRegistration;
  final String idCard;
  final String fullName;
  final String status;

  EmployeeOsDataEntity({
    required this.id,
    required this.noRegistration,
    required this.idCard,
    required this.fullName,
    required this.status,
  });
}
