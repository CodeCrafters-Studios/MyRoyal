import 'package:equatable/equatable.dart';

class WebtelData extends Equatable {
  final String fullName;
  final String departmentName;
  final int? lineNumber;
  final dynamic extentionNumber;
  final dynamic workEmail;

  const WebtelData({
    required this.fullName,
    required this.departmentName,
    required this.lineNumber,
    required this.extentionNumber,
    required this.workEmail,
  });

  @override
  List<Object?> get props => [
        fullName,
        departmentName,
        lineNumber,
        extentionNumber,
        workEmail,
      ];
}
