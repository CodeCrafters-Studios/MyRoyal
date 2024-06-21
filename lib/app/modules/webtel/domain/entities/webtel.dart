import 'package:equatable/equatable.dart';

class Webtel extends Equatable {
  const Webtel({
    required this.fullname,
    required this.departmentName,
    required this.lineNumber,
    required this.extentionNumber,
    required this.branchName,
    required this.workEmail,
  });

  final String fullname;
  final String departmentName;
  final int lineNumber;
  final int extentionNumber;
  final String branchName;
  final String workEmail;

  @override
  List<Object?> get props => [
        fullname,
        departmentName,
        lineNumber,
        extentionNumber,
        branchName,
        workEmail,
      ];
}
