import 'package:equatable/equatable.dart';

class Menu extends Equatable {
  const Menu({
    required this.id,
    required this.code,
    required this.name,
  });

  final int id;
  final String code;
  final String name;

  @override
  List<Object?> get props => [
        id,
        code,
        name,
      ];
}
