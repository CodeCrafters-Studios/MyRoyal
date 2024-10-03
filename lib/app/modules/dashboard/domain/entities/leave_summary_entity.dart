import 'package:equatable/equatable.dart';

class LeaveSummaryEntity extends Equatable {
  const LeaveSummaryEntity(this.late, this.absent, this.specialLeaves);

  final int? late;
  final int? absent;
  final int? specialLeaves;

  @override
  List<Object?> get props => [late, absent, specialLeaves];
}
