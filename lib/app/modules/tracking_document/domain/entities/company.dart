import 'package:equatable/equatable.dart';

class Company extends Equatable {
  const Company({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}
