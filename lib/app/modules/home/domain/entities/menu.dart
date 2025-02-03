import 'package:equatable/equatable.dart';

class Menu extends Equatable {
  const Menu({
    required this.code,
    required this.name,
  });

  final String code;
  final String name;

  @override
  List<Object?> get props => [
        code,
        name,
      ];
}
