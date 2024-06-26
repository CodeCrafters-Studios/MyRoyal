import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/edit_profile/domain/entities/employee_params.dart';

class EditProfile extends Equatable {
  const EditProfile({required this.employeeParams});

  final EmployeeParams employeeParams;

  @override
  List<Object?> get props => [
        employeeParams,
      ];
}
