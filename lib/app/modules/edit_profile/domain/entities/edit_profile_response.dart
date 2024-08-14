import 'package:equatable/equatable.dart';

class EditProfileResponse extends Equatable {
  const EditProfileResponse({
    required this.status,
    required this.code,
    required this.message,
    required this.data,
  });

  final bool status;
  final int code;
  final String message;
  final String data;

  @override
  List<Object?> get props => [
        status,
        code,
        message,
        data,
      ];
}
