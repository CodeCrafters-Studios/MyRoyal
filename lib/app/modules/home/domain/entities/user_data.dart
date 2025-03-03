import 'package:equatable/equatable.dart';

class UserData extends Equatable {
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
  final bool canAccessLeave;

  const UserData({
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
    required this.canAccessLeave,
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
        canAccessLeave,
      ];
}
