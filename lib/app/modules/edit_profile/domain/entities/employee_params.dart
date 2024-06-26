import 'package:equatable/equatable.dart';

class EmployeeParams extends Equatable {
  const EmployeeParams({
    required this.lastName,
    required this.npwp,
  });

  final String lastName;
  final String npwp;

  @override
  List<Object?> get props => [
        lastName,
        npwp,
      ];
}
