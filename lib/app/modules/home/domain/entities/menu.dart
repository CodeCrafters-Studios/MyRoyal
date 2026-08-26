import 'package:equatable/equatable.dart';

class Menu extends Equatable {
  const Menu({
    required this.id,
    required this.code,
    required this.name,
    this.isVisible = true,
  });

  final int id;
  final String code;
  final String name;
  final bool isVisible;

  @override
  List<Object?> get props => [
        id,
        code,
        name,
        isVisible,
      ];
}
