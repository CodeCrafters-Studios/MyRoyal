import 'package:equatable/equatable.dart';

class Menu extends Equatable {
  const Menu({
    required this.code,
    required this.name,
    required this.isVisible,
  });

  final String code;
  final String name;
  final bool isVisible;

  @override
  List<Object?> get props => [
        code,
        name,
        isVisible,
      ];
}
