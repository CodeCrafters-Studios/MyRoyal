import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  const Profile({
    required this.fullName,
    required this.company,
    required this.department,
    required this.position,
    required this.reportTo,
    required this.remainingLeave,
    required this.birthdate,
    required this.email,
    required this.gender,
    required this.instagram,
    required this.linkedin,
  });

  final String fullName;
  final String company;
  final String department;
  final String position;
  final String reportTo;
  final int remainingLeave;
  final DateTime birthdate;
  final String email;
  final String gender;
  final String instagram;
  final String linkedin;

  @override
  List<Object?> get props => [
        fullName,
        company,
        department,
        position,
        reportTo,
        remainingLeave,
        birthdate,
        email,
        gender,
        instagram,
        linkedin,
      ];
}
