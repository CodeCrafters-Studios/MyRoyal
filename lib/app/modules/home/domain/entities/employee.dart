import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  const Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthdate,
    required this.gender,
    required this.maritalStatus,
    required this.availableLeave,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String birthdate;
  final String gender;
  final String maritalStatus;
  final int availableLeave;

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        birthdate,
        gender,
        maritalStatus,
        availableLeave
      ];
}
