import 'package:equatable/equatable.dart';

class EditProfileResponse extends Equatable {
  const EditProfileResponse({
    required this.status,
    required this.message,
    required this.employee,
  });

  final String status;
  final String message;
  final String employee;

  @override
  List<Object?> get props => [
        status,
        message,
        employee,
      ];
}
