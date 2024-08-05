import 'package:equatable/equatable.dart';

class CacheUserLogin extends Equatable {
  const CacheUserLogin({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  @override
  List<Object?> get props => [
        username,
        password,
      ];
}
