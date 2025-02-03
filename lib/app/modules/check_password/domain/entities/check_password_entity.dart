import 'package:equatable/equatable.dart';

class CheckPasswordEntity extends Equatable {
  final int code;
  final String message;
  final bool data;

  const CheckPasswordEntity(
      {required this.code, required this.message, required this.data});

  @override
  List<Object?> get props => [code, message, data];
}
