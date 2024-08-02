import 'package:equatable/equatable.dart';

class Personal extends Equatable {
  const Personal({
    required this.id,
    required this.fullName,
    required this.lastName,
    required this.birthdate,
    required this.gender,
    required this.maritalStatus,
    required this.nickname,
    required this.idCard,
    required this.birthplace,
    required this.instagram,
    required this.linkedin,
    required this.npwp,
    required this.npwpStatus,
    required this.smoker,
    required this.personalEmail,
  });

  final int id;
  final String fullName;
  final String lastName;
  final DateTime birthdate;
  final String gender;
  final String maritalStatus;
  final String nickname;
  final String idCard;
  final String birthplace;
  final String instagram;
  final String linkedin;
  final String npwp;
  final String npwpStatus;
  final bool smoker;
  final String personalEmail;

  @override
  List<Object?> get props => [
        id,
        fullName,
        lastName,
        birthdate,
        gender,
        maritalStatus,
        nickname,
        idCard,
        birthplace,
        instagram,
        linkedin,
        npwp,
        npwpStatus,
        smoker,
        personalEmail,
      ];
}
