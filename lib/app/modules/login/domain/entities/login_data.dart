import 'package:equatable/equatable.dart';
import 'package:MyRoyal/app/modules/login/data/models/token_response.dart';

class LoginDataResponse extends Equatable {
  const LoginDataResponse({required this.token});

  final TokenResponseModel token;

  @override
  List<Object?> get props => [token];
}
