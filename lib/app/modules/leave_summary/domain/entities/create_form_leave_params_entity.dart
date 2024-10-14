import 'package:equatable/equatable.dart';

class CreateFormLeaveParamsEntity extends Equatable {
  const CreateFormLeaveParamsEntity({
    required this.substituteId,
    required this.dateLeave,
    required this.reason,
  });

  final int substituteId;
  final List<String> dateLeave;
  final String reason;

  Map<String, dynamic> toMap() {
    return {
      'substitute_id': substituteId,
      'date_leave': dateLeave,
      'reason': reason,
    };
  }

  @override
  List<Object?> get props => [substituteId, dateLeave, reason];
}
