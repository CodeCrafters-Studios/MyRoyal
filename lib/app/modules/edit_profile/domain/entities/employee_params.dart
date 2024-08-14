import 'package:equatable/equatable.dart';

class EmployeeParams extends Equatable {
  const EmployeeParams({
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.npwp,
    required this.npwpStatus,
    required this.email,
    required this.instagram,
    required this.linkedIn,
    required this.maritalStatus,
  });

  final int employeeId;
  final String firstName;
  final String lastName;
  final String nickname;
  final String npwp;
  final String npwpStatus;
  final String email;
  final String instagram;
  final String linkedIn;
  final String maritalStatus;

  @override
  List<Object?> get props => [
        firstName,
        // lastName,
        nickname,
        npwp,
        npwpStatus,
        email,
        instagram,
        linkedIn,
        maritalStatus,
      ];
}
