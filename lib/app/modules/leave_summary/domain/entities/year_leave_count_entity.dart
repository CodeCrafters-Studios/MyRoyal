import 'package:equatable/equatable.dart';

class YearLeaveCountEntity extends Equatable {
  const YearLeaveCountEntity(
      {required this.used, required this.remaining, required this.max});

  final int? used;
  final int? remaining;
  final int? max;

  @override
  List<Object?> get props => [used, remaining, max];
}
