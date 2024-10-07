import 'package:equatable/equatable.dart';

class Personal extends Equatable {
  const Personal({
    required this.fullName,
    required this.firstName,
    required this.lastName,
    required this.nickname,
    required this.birthdate,
    required this.birthplace,
    required this.gender,
    required this.maritalStatus,
    required this.npwp,
    required this.npwpStatus,
    required this.personalEmail,
    required this.instagram,
    required this.linkedin,
    required this.profilePicture,
  });

  final String fullName;
  final String firstName;
  final String lastName;
  final String nickname;
  final DateTime birthdate;
  final String birthplace;
  final String gender;
  final String maritalStatus;
  final String npwp;
  final String npwpStatus;
  final String personalEmail;
  final String instagram;
  final String linkedin;
  final String profilePicture;

  @override
  List<Object?> get props => [
        fullName,
        birthdate,
        gender,
        maritalStatus,
        nickname,
        birthplace,
        instagram,
        linkedin,
        npwp,
        npwpStatus,
        personalEmail,
        profilePicture,
      ];
}
