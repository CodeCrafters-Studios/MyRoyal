import 'package:equatable/equatable.dart';

class Webtel extends Equatable {
  const Webtel({
    required this.ext,
    required this.fullname,
    required this.departmentName,
    required this.branchName,
  });

  final String ext;
  final String fullname;
  final String departmentName;
  final String branchName;

  @override
  List<Object?> get props => [
        ext,
        fullname,
        departmentName,
        branchName,
      ];
}
