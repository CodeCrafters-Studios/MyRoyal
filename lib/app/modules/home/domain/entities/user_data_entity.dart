import 'package:MyRoyal/app/modules/home/data/models/user_data_model.dart';
import 'package:equatable/equatable.dart';

class UserDataEntity extends Equatable {
  final int userId;
  final int employeeId;
  final String email;
  final String fullName;
  final String employeeNumber;
  final String position;
  final String department;
  final String joinDate;
  final String initialName;
  final String profilePicture;
  final String absentStartDay;
  final String absentEndDay;
  final String absentStartTime;
  final String absentEndTime;
  final bool canAccessPtk;
  final bool shouldCreatePin;
  final bool canSubmissionLeave;
  final String username;
  final int countNotification;
  final bool banned;
  final dynamic bannedAt;
  final MenuPermissionModel menuPermission;

  UserDataEntity({
    required this.userId,
    required this.employeeId,
    required this.email,
    required this.fullName,
    required this.employeeNumber,
    required this.position,
    required this.department,
    required this.joinDate,
    required this.initialName,
    required this.profilePicture,
    required this.absentStartDay,
    required this.absentEndDay,
    required this.absentStartTime,
    required this.absentEndTime,
    required this.canAccessPtk,
    required this.shouldCreatePin,
    required this.canSubmissionLeave,
    required this.username,
    required this.countNotification,
    required this.banned,
    required this.bannedAt,
    required this.menuPermission,
  });

  @override
  List<Object?> get props => [
        employeeId,
        email,
        fullName,
        employeeNumber,
        position,
        department,
        joinDate,
        initialName,
        profilePicture,
        absentStartDay,
        absentEndDay,
        absentStartTime,
        absentEndTime,
        canSubmissionLeave,
        username,
        countNotification,
        banned,
        bannedAt,
        menuPermission,
      ];
}

class MenuPermissionEntity {
  final bool ptkOcr;

  MenuPermissionEntity({
    required this.ptkOcr,
  });
}
