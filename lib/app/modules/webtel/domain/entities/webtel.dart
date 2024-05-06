import 'package:equatable/equatable.dart';

class Webtel extends Equatable {
  const Webtel({
    required this.fullname,
    required this.departmentName,
    required this.ext,
    required this.branchName,
    required this.id,
  });

  final String fullname;
  final String departmentName;
  final int ext;
  final String branchName;
  final String id;

  @override
  List<Object?> get props => [
        fullname,
        departmentName,
        ext,
        branchName,
        id,
      ];
}
