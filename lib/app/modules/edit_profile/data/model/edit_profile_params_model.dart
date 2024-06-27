import 'package:iroyal/app/modules/edit_profile/data/model/employee_params_model.dart';
import 'package:iroyal/app/modules/edit_profile/domain/entities/edit_profile.dart';

class EditProfileParamsModel extends EditProfile {
  const EditProfileParamsModel({required super.employeeParams});

  factory EditProfileParamsModel.fromJson(Map<String, dynamic> json) =>
      EditProfileParamsModel(
        employeeParams: EmployeeParamsModel.fromJson(json["employee"]),
      );
}
