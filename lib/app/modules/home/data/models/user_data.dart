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
    required super.absentStartDay,
    required super.absentEndDay,
    required super.absentStartTime,
    required super.absentEndTime,
    required super.canAccessLeave,
    required super.username,
    required super.countNotification,
  });

  factory UserDataModel.empty() => const UserDataModel(
        employeeId: 0,
        email: '',
        fullName: '',
        employeeNumber: '',
        position: '',
        department: '',
        joinDate: '',
        initialName: '',
        profilePicture: '',
        absentStartDay: '',
        absentEndDay: '',
        absentStartTime: '',
        absentEndTime: '',
        canAccessLeave: false,
        username: '',
        countNotification: 0,
      );

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
        employeeId: json["employee_id"] ?? '',
        email: json["email"] ?? '',
        fullName: json["full_name"] ?? '',
        employeeNumber: json["employee_number"] ?? '',
        position: json["position"] ?? '',
        department: json["department"] ?? '',
        joinDate: json["join_date"] ?? '',
        initialName: json["initial_name"] ?? '',
        profilePicture: json["profile_picture"] ?? '',
        absentStartDay: json["absent_start_day"] ?? '',
        absentEndDay: json["absent_end_day"] ?? '',
        absentStartTime: json["absent_start_time"] ?? '',
        absentEndTime: json["absent_end_time"] ?? '',
        canAccessLeave: json["can_submission_leave"] ?? false,
        username: json["username"] ?? '',
        countNotification: json["count_notification"] ?? 0,
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
        "absentStartDay": absentStartDay,
        "absentEndDay": absentEndDay,
        "absentStartTime": absentStartTime,
        "absentEndTime": absentEndTime,
        "can_submission_leave": canAccessLeave,
        "username": username,
        "count_notification": countNotification,
      };
}
