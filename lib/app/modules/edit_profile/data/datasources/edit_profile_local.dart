import 'package:iroyal/app/modules/edit_profile/data/model/edit_profile_params_model.dart';
import 'package:iroyal/app/modules/edit_profile/domain/entities/employee_params.dart';

abstract class EditProfileLocalDataSource {
  Future<EditProfileParamsModel> editProfile({
    required EmployeeParams employeeParams,
  });
}

class EditProfileLocalDataSourceImpl implements EditProfileLocalDataSource {
  EditProfileLocalDataSourceImpl();

  @override
  Future<EditProfileParamsModel> editProfile(
      {required EmployeeParams employeeParams}) async {
    return editProfile(
      employeeParams: employeeParams,
    );
  }
}
