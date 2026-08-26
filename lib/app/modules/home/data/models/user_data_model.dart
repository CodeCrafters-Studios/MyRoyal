import 'package:MyRoyal/app/modules/home/domain/entities/user_data_entity.dart';

class UserDataModel extends UserDataEntity {
  UserDataModel({
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
    required super.canSubmissionLeave,
    required super.username,
    required super.countNotification,
    required super.userId,
    required super.canAccessPtk,
    required super.shouldCreatePin,
    required super.banned,
    required super.bannedAt,
    required super.menuPermission,
  });

  factory UserDataModel.empty() => UserDataModel(
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
        canSubmissionLeave: false,
        username: '',
        countNotification: 0,
        userId: 0,
        canAccessPtk: false,
        shouldCreatePin: false,
        banned: false,
        bannedAt: null,
        menuPermission: MenuPermissionModel.empty(),
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
        canSubmissionLeave: json["can_submission_leave"] ?? false,
        username: json["username"] ?? '',
        countNotification: json["count_notification"] ?? 0,
        userId: json["user_id"] ?? 0,
        canAccessPtk: json["can_access_ptk"] ?? false,
        shouldCreatePin: json["should_create_pin"] ?? false,
        banned: json["banned"] ?? false,
        bannedAt: json["banned_at"] ?? null,
        menuPermission:
            MenuPermissionModel.fromJson(json["menu_permission"] ?? {}),
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
        "can_submission_leave": canSubmissionLeave,
        "username": username,
        "count_notification": countNotification,
        "user_id": userId,
        "can_access_ptk": canAccessPtk,
        "should_create_pin": shouldCreatePin,
        "banned": banned,
        "banned_at": bannedAt,
        "menu_permission": menuPermission.toJson(),
      };
}

class MenuPermissionModel extends MenuPermissionEntity {
  MenuPermissionModel({required super.ptkOcr});

  factory MenuPermissionModel.fromJson(Map<String, dynamic> json) =>
      MenuPermissionModel(
        ptkOcr: json["ptk_ocr"],
      );

  factory MenuPermissionModel.empty() => MenuPermissionModel(
        ptkOcr: false,
      );

  Map<String, dynamic> toJson() => {
        "ptk_ocr": ptkOcr,
      };
}
