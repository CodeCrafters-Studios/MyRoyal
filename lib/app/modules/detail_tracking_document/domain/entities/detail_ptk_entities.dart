import 'package:equatable/equatable.dart';

class DetailPtkEntities extends Equatable {
  final dynamic fileAttachment;
  final String reason;
  final String laborQuantity;
  final String employmentStatusesName;
  final String jobDescription;
  final String requirement;
  final String reasonDescription;
  final String state;

  const DetailPtkEntities({
    required this.fileAttachment,
    required this.reason,
    required this.laborQuantity,
    required this.employmentStatusesName,
    required this.jobDescription,
    required this.requirement,
    required this.reasonDescription,
    required this.state,
  });

  @override
  List<Object?> get props => [
        fileAttachment,
        reason,
        laborQuantity,
        employmentStatusesName,
        jobDescription,
        requirement,
        reasonDescription,
        state,
      ];
}
