import 'package:equatable/equatable.dart';

class CreateFormPermitParamsEntity extends Equatable {
  const CreateFormPermitParamsEntity({
    required this.typeCode,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.reason,
  });

  final String typeCode, startDate, endDate, startTime, endTime, reason;

  Map<String, dynamic> toMap() {
    return {
      'type': typeCode,
      'startdate': startDate,
      'enddate': endDate,
      'starttime': startTime,
      'endtime': endTime,
      'reason': reason,
    };
  }

  @override
  List<Object?> get props => [
        typeCode,
        startDate,
        endDate,
        startTime,
        endTime,
        reason,
      ];
}
