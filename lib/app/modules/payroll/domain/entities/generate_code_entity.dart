import 'package:equatable/equatable.dart';

class GenerateCodeEntity extends Equatable {
  GenerateCodeEntity({
    required this.password,
  });

  final String? password;

  @override
  List<Object?> get props => [password];
}
