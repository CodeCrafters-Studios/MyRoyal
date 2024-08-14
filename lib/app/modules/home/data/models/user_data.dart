import 'package:iroyal/app/modules/home/domain/entities/user_data.dart';

class UserDataModel extends UserData {
  const UserDataModel({
    required super.employeeId,
    required super.email,
    required super.fullName,
    required super.employeeNumber,
    required super.position,
    required super.department,
    required super.joinDate,
    required super.initialName,
    required super.profilePicture,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
        employeeId: json["employee_id"],
        email: json["email"],
        fullName: json["full_name"],
        employeeNumber: json["employee_number"],
        position: json["position"],
        department: json["department"],
        joinDate: json["join_date"],
        initialName: json["initial_name"],
        profilePicture: json["profile_picture"],
      );

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "email": email,
        "full_name": fullName,
        "employee_number": employeeNumber,
        "position": position,
        "department": department,
        "join_date": joinDate,
        "initial_name": initialName,
        "profile_picture": profilePicture,
      };
}
