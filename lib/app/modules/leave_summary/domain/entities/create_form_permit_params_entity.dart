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
