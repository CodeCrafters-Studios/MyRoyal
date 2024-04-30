import 'package:equatable/equatable.dart';

class GenderDistribution extends Equatable {
  const GenderDistribution({
    required this.male,
    required this.female,
  });

  final double male;
  final double female;

  @override
  List<Object?> get props => [
        male,
        female,
      ];
}
