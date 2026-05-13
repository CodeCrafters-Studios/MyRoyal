import 'package:equatable/equatable.dart';

class EmployeeParamsEntity extends Equatable {
  const EmployeeParamsEntity({
    required this.employeeId,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.email,
    required this.instagram,
    required this.linkedIn,
    required this.maritalStatus,
    required this.birthDate,
    required this.birthPlace,
    required this.gender,
    required this.profilePicture,
  });

  final int employeeId;
  final String firstName;
  final String lastName;
  final String nickname;
  final String email;
  final String instagram;
  final String linkedIn;
  final String maritalStatus;
  final String birthPlace;
  final String birthDate;
  final String gender;
  final String profilePicture;

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        nickname,
        email,
        instagram,
        linkedIn,
        maritalStatus,
        birthPlace,
        birthDate,
        gender,
        profilePicture,
      ];
}
