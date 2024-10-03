import 'package:equatable/equatable.dart';

class PtkEntity extends Equatable {
  const PtkEntity(this.open, this.closed, this.total);

  final int? open;
  final int? closed;
  final int? total;

  @override
  List<Object?> get props => [open, closed, total];
}
