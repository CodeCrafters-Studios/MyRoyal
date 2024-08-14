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
        profilePicture
      ];
}
