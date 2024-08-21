import 'package:equatable/equatable.dart';

class EditProfileResponse extends Equatable {
  const EditProfileResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  final int code;
  final String message;
  final List<dynamic> data;

  @override
  List<Object?> get props => [
        code,
        message,
        data,
      ];
}
