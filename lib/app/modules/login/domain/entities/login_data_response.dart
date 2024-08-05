import 'package:equatable/equatable.dart';

class LoginDataResponse extends Equatable {
  const LoginDataResponse({required this.accessToken});

  final String accessToken;

  @override
  List<Object?> get props => [accessToken];
}
