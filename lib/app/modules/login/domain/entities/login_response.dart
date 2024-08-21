import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/login/data/models/login_data.dart';

class LoginResponse extends Equatable {
  const LoginResponse({
    required this.code,
    required this.message,
    required this.data,
  });

  final int code;
  final String message;
  final LoginData data;

  @override
  List<Object?> get props => [
        code,
        message,
        data,
      ];
}
